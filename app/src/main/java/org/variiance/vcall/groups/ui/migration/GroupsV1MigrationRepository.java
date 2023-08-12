package org.variiance.vcall.groups.ui.migration;

import androidx.annotation.NonNull;
import androidx.annotation.WorkerThread;
import androidx.core.util.Consumer;

import com.annimon.stream.Stream;

import org.signal.core.util.concurrent.SignalExecutors;
import org.signal.core.util.logging.Log;
import org.variiance.vcall.database.RecipientTable;
import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.variiance.vcall.groups.GroupChangeBusyException;
import org.variiance.vcall.groups.GroupsV1MigrationUtil;
import org.variiance.vcall.jobmanager.impl.NetworkConstraint;
import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.recipients.RecipientId;
import org.variiance.vcall.recipients.RecipientUtil;
import org.variiance.vcall.transport.RetryLaterException;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

final class GroupsV1MigrationRepository {

  private static final String TAG = Log.tag(GroupsV1MigrationRepository.class);

  void getMigrationState(@NonNull RecipientId groupRecipientId, @NonNull Consumer<MigrationState> callback) {
    SignalExecutors.BOUNDED.execute(() -> callback.accept(getMigrationState(groupRecipientId)));
  }

  void upgradeGroup(@NonNull RecipientId recipientId, @NonNull Consumer<MigrationResult> callback) {
    SignalExecutors.UNBOUNDED.execute(() -> {
      if (!NetworkConstraint.isMet(ApplicationDependencies.getApplication())) {
        Log.w(TAG, "No network!");
        callback.accept(MigrationResult.FAILURE_NETWORK);
        return;
      }

      if (!Recipient.resolved(recipientId).isPushV1Group()) {
        Log.w(TAG, "Not a V1 group!");
        callback.accept(MigrationResult.FAILURE_GENERAL);
        return;
      }

      try {
        GroupsV1MigrationUtil.migrate(ApplicationDependencies.getApplication(), recipientId, true);
        callback.accept(MigrationResult.SUCCESS);
      } catch (IOException | RetryLaterException | GroupChangeBusyException e) {
        callback.accept(MigrationResult.FAILURE_NETWORK);
      } catch (GroupsV1MigrationUtil.InvalidMigrationStateException e) {
        callback.accept(MigrationResult.FAILURE_GENERAL);
      }
    });
  }

  @WorkerThread
  private MigrationState getMigrationState(@NonNull RecipientId groupRecipientId) {
    Recipient group = Recipient.resolved(groupRecipientId);

    if (!group.isPushV1Group()) {
      return new MigrationState(Collections.emptyList(), Collections.emptyList());
    }

    List<Recipient> members = Recipient.resolvedList(group.getParticipantIds());

    try {
      List<Recipient> registered = Stream.of(members)
                                         .filter(Recipient::isRegistered)
                                         .toList();

      RecipientUtil.ensureUuidsAreAvailable(ApplicationDependencies.getApplication(), registered);
    } catch (IOException e) {
      Log.w(TAG, "Failed to refresh UUIDs!", e);
    }

    group = group.fresh();

    List<Recipient> ineligible = Stream.of(members)
                                       .filter(r -> !r.hasServiceId() || r.getRegistered() != RecipientTable.RegisteredState.REGISTERED)
                                       .toList();

    List<Recipient> invites = Stream.of(members)
                                    .filterNot(ineligible::contains)
                                    .filterNot(Recipient::isSelf)
                                    .filter(r -> r.getProfileKey() == null)
                                    .toList();

    return new MigrationState(invites, ineligible);
  }
}
