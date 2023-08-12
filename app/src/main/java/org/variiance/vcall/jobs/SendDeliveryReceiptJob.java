package org.variiance.vcall.jobs;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.signal.core.util.logging.Log;
import org.variiance.vcall.crypto.UnidentifiedAccessUtil;
import org.variiance.vcall.database.SignalDatabase;
import org.variiance.vcall.database.model.MessageId;
import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.variiance.vcall.jobmanager.JsonJobData;
import org.variiance.vcall.jobmanager.Job;
import org.variiance.vcall.jobmanager.impl.NetworkConstraint;
import org.variiance.vcall.net.NotPushRegisteredException;
import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.recipients.RecipientId;
import org.variiance.vcall.recipients.RecipientUtil;
import org.variiance.vcall.transport.UndeliverableMessageException;
import org.whispersystems.signalservice.api.SignalServiceMessageSender;
import org.whispersystems.signalservice.api.crypto.ContentHint;
import org.whispersystems.signalservice.api.crypto.UntrustedIdentityException;
import org.whispersystems.signalservice.api.messages.SendMessageResult;
import org.whispersystems.signalservice.api.messages.SignalServiceReceiptMessage;
import org.whispersystems.signalservice.api.push.SignalServiceAddress;
import org.whispersystems.signalservice.api.push.exceptions.PushNetworkException;
import org.whispersystems.signalservice.api.push.exceptions.ServerRejectedException;

import java.io.IOException;
import java.util.Collections;
import java.util.concurrent.TimeUnit;

public class SendDeliveryReceiptJob extends BaseJob {

  public static final String KEY = "SendDeliveryReceiptJob";

  private static final String KEY_RECIPIENT              = "recipient";
  private static final String KEY_MESSAGE_SENT_TIMESTAMP = "message_id";
  private static final String KEY_TIMESTAMP              = "timestamp";
  private static final String KEY_MESSAGE_ID             = "message_db_id";

  private static final String TAG = Log.tag(SendReadReceiptJob.class);

  private final RecipientId recipientId;
  private final long        messageSentTimestamp;
  private final long        timestamp;

  @Nullable
  private final MessageId messageId;

  public SendDeliveryReceiptJob(@NonNull RecipientId recipientId, long messageSentTimestamp, @NonNull MessageId messageId) {
    this(new Job.Parameters.Builder()
                           .addConstraint(NetworkConstraint.KEY)
                           .setLifespan(TimeUnit.DAYS.toMillis(1))
                           .setMaxAttempts(Parameters.UNLIMITED)
                           .setQueue(recipientId.toQueueKey())
                           .build(),
         recipientId,
         messageSentTimestamp,
         messageId,
         System.currentTimeMillis());
  }

  private SendDeliveryReceiptJob(@NonNull Job.Parameters parameters,
                                 @NonNull RecipientId recipientId,
                                 long messageSentTimestamp,
                                 @Nullable MessageId messageId,
                                 long timestamp)
  {
    super(parameters);

    this.recipientId          = recipientId;
    this.messageSentTimestamp = messageSentTimestamp;
    this.messageId            = messageId;
    this.timestamp            = timestamp;
  }

  @Override
  public @Nullable byte[] serialize() {
    JsonJobData.Builder builder = new JsonJobData.Builder().putString(KEY_RECIPIENT, recipientId.serialize())
                                                           .putLong(KEY_MESSAGE_SENT_TIMESTAMP, messageSentTimestamp)
                                                           .putLong(KEY_TIMESTAMP, timestamp);

    if (messageId != null) {
      builder.putString(KEY_MESSAGE_ID, messageId.serialize());
    }

    return builder.serialize();
  }

  @Override
  public @NonNull String getFactoryKey() {
    return KEY;
  }

  @Override
  public void onRun() throws IOException, UntrustedIdentityException, UndeliverableMessageException {
    if (!Recipient.self().isRegistered()) {
      throw new NotPushRegisteredException();
    }

    SignalServiceMessageSender  messageSender  = ApplicationDependencies.getSignalServiceMessageSender();
    Recipient                   recipient      = Recipient.resolved(recipientId);

    if (recipient.isSelf()) {
      Log.i(TAG, "Not sending to self, abort");
      return;
    }

    if (recipient.isUnregistered()) {
      Log.w(TAG, recipient.getId() + " is unregistered!");
      return;
    }

    if (!recipient.hasServiceId() && !recipient.hasE164()) {
      Log.w(TAG, "No serviceId or e164!");
      return;
    }

    SignalServiceAddress        remoteAddress  = RecipientUtil.toSignalServiceAddress(context, recipient);
    SignalServiceReceiptMessage receiptMessage = new SignalServiceReceiptMessage(SignalServiceReceiptMessage.Type.DELIVERY,
                                                                                 Collections.singletonList(messageSentTimestamp),
                                                                                 timestamp);

    SendMessageResult result = messageSender.sendReceipt(remoteAddress,
                                                         UnidentifiedAccessUtil.getAccessFor(context, recipient),
                                                         receiptMessage,
                                                         recipient.needsPniSignature());

    if (messageId != null) {
      SignalDatabase.messageLog().insertIfPossible(recipientId, timestamp, result, ContentHint.IMPLICIT, messageId, false);
    }
  }

  @Override
  public boolean onShouldRetry(@NonNull Exception e) {
    if (e instanceof ServerRejectedException) return false;
    if (e instanceof PushNetworkException) return true;
    return false;
  }

  @Override
  public void onFailure() {
    Log.w(TAG, "Failed to send delivery receipt to: " + recipientId);
  }

  public static final class Factory implements Job.Factory<SendDeliveryReceiptJob> {
    @Override
    public @NonNull SendDeliveryReceiptJob create(@NonNull Parameters parameters, @Nullable byte[] serializedData) {
      JsonJobData data = JsonJobData.deserialize(serializedData);

      MessageId messageId = null;

      if (data.hasString(KEY_MESSAGE_ID)) {
        messageId = MessageId.deserialize(data.getString(KEY_MESSAGE_ID));
      }

      return new SendDeliveryReceiptJob(parameters,
                                        RecipientId.from(data.getString(KEY_RECIPIENT)),
                                        data.getLong(KEY_MESSAGE_SENT_TIMESTAMP),
                                        messageId,
                                        data.getLong(KEY_TIMESTAMP));
    }
  }
}
