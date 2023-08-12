package org.variiance.vcall.notifications;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;

import org.signal.core.util.Stopwatch;
import org.signal.core.util.concurrent.SignalExecutors;
import org.signal.core.util.logging.Log;
import org.variiance.vcall.database.MessageTable.ExpirationInfo;
import org.variiance.vcall.database.MessageTable.MarkedMessageInfo;
import org.variiance.vcall.database.MessageTable.SyncMessageId;
import org.variiance.vcall.database.SignalDatabase;
import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.variiance.vcall.jobs.MultiDeviceReadUpdateJob;
import org.variiance.vcall.jobs.SendReadReceiptJob;
import org.variiance.vcall.notifications.v2.ConversationId;
import org.variiance.vcall.recipients.RecipientId;
import org.variiance.vcall.service.ExpiringMessageManager;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class MarkReadReceiver extends BroadcastReceiver {

  private static final String TAG                   = Log.tag(MarkReadReceiver.class);
  public static final  String CLEAR_ACTION          = "org.variiance.vcall.notifications.CLEAR";
  public static final  String THREADS_EXTRA         = "threads";
  public static final  String NOTIFICATION_ID_EXTRA = "notification_id";

  @SuppressLint("StaticFieldLeak")
  @Override
  public void onReceive(final Context context, Intent intent) {
    if (!CLEAR_ACTION.equals(intent.getAction()))
      return;

    final ArrayList<ConversationId> threads = intent.getParcelableArrayListExtra(THREADS_EXTRA);

    if (threads != null) {
      MessageNotifier notifier = ApplicationDependencies.getMessageNotifier();
      for (ConversationId thread : threads) {
        notifier.removeStickyThread(thread);
      }

      NotificationCancellationHelper.cancelLegacy(context, intent.getIntExtra(NOTIFICATION_ID_EXTRA, -1));

      PendingResult finisher = goAsync();
      SignalExecutors.BOUNDED.execute(() -> {
        List<MarkedMessageInfo> messageIdsCollection = new LinkedList<>();

        for (ConversationId thread : threads) {
          Log.i(TAG, "Marking as read: " + thread);
          List<MarkedMessageInfo> messageIds = SignalDatabase.threads().setRead(thread, true);
          messageIdsCollection.addAll(messageIds);
        }

        process(context, messageIdsCollection);

        ApplicationDependencies.getMessageNotifier().updateNotification(context);
        finisher.finish();
      });
    }
  }

  public static void process(@NonNull Context context, @NonNull List<MarkedMessageInfo> markedReadMessages) {
    if (markedReadMessages.isEmpty()) return;

    List<SyncMessageId>  syncMessageIds = Stream.of(markedReadMessages)
                                                .map(MarkedMessageInfo::getSyncMessageId)
                                                .toList();
    List<ExpirationInfo> expirationInfo = Stream.of(markedReadMessages)
                                                .map(MarkedMessageInfo::getExpirationInfo)
                                                .filter(info -> info.getExpiresIn() > 0 && info.getExpireStarted() <= 0)
                                                .toList();

    scheduleDeletion(expirationInfo);

    MultiDeviceReadUpdateJob.enqueue(syncMessageIds);

    Map<Long, List<MarkedMessageInfo>> threadToInfo = Stream.of(markedReadMessages)
                                                            .collect(Collectors.groupingBy(MarkedMessageInfo::getThreadId));

    Stream.of(threadToInfo).forEach(threadToInfoEntry -> {
      Map<RecipientId, List<MarkedMessageInfo>> recipientIdToInfo = Stream.of(threadToInfoEntry.getValue())
                                                                          .map(info -> info)
                                                                          .collect(Collectors.groupingBy(info -> info.getSyncMessageId().getRecipientId()));

      Stream.of(recipientIdToInfo).forEach(entry -> {
        long                    threadId    = threadToInfoEntry.getKey();
        RecipientId             recipientId = entry.getKey();
        List<MarkedMessageInfo> infos       = entry.getValue();

        SendReadReceiptJob.enqueue(threadId, recipientId, infos);
      });
    });
  }

  private static void scheduleDeletion(@NonNull List<ExpirationInfo> expirationInfo) {
    if (expirationInfo.size() > 0) {
      SignalDatabase.messages().markExpireStarted(Stream.of(expirationInfo).map(ExpirationInfo::getId).toList(), System.currentTimeMillis());

      ExpiringMessageManager expirationManager = ApplicationDependencies.getExpiringMessageManager();

      expirationInfo.stream().forEach(info -> expirationManager.scheduleDeletion(info.getId(), info.isMms(), info.getExpiresIn()));
    }
  }
}
