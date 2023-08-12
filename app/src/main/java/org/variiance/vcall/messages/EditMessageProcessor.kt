package org.variiance.vcall.messages

import android.content.Context
import org.signal.core.util.concurrent.SignalExecutors
import org.signal.core.util.orNull
import org.variiance.vcall.database.MessageTable.InsertResult
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.model.MediaMmsMessageRecord
import org.variiance.vcall.database.model.MessageId
import org.variiance.vcall.database.model.databaseprotos.BodyRangeList
import org.variiance.vcall.database.model.toBodyRangeList
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.jobs.PushProcessEarlyMessagesJob
import org.variiance.vcall.jobs.SendDeliveryReceiptJob
import org.variiance.vcall.messages.MessageContentProcessorV2.Companion.log
import org.variiance.vcall.messages.MessageContentProcessorV2.Companion.warn
import org.variiance.vcall.messages.SignalServiceProtoUtil.groupId
import org.variiance.vcall.messages.SignalServiceProtoUtil.isMediaMessage
import org.variiance.vcall.messages.SignalServiceProtoUtil.toPointersWithinLimit
import org.variiance.vcall.mms.IncomingMediaMessage
import org.variiance.vcall.mms.QuoteModel
import org.variiance.vcall.notifications.v2.ConversationId.Companion.forConversation
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.sms.IncomingEncryptedMessage
import org.variiance.vcall.sms.IncomingTextMessage
import org.variiance.vcall.util.EarlyMessageCacheEntry
import org.variiance.vcall.util.MediaUtil
import org.variiance.vcall.util.MessageConstraintsUtil
import org.variiance.vcall.util.hasAudio
import org.variiance.vcall.util.hasSharedContact
import org.whispersystems.signalservice.api.crypto.EnvelopeMetadata
import org.whispersystems.signalservice.internal.push.SignalServiceProtos
import org.whispersystems.signalservice.internal.push.SignalServiceProtos.DataMessage
import java.util.Optional

object EditMessageProcessor {
  fun process(
    context: Context,
    senderRecipient: Recipient,
    threadRecipient: Recipient,
    envelope: SignalServiceProtos.Envelope,
    content: SignalServiceProtos.Content,
    metadata: EnvelopeMetadata,
    earlyMessageCacheEntry: EarlyMessageCacheEntry?
  ) {
    val editMessage = content.editMessage

    log(envelope.timestamp, "[handleEditMessage] Edit message for " + editMessage.targetSentTimestamp)

    var targetMessage: MediaMmsMessageRecord? = SignalDatabase.messages.getMessageFor(editMessage.targetSentTimestamp, senderRecipient.id) as? MediaMmsMessageRecord
    val targetThreadRecipient: Recipient? = if (targetMessage != null) SignalDatabase.threads.getRecipientForThreadId(targetMessage.threadId) else null

    if (targetMessage == null || targetThreadRecipient == null) {
      warn(envelope.timestamp, "[handleEditMessage] Could not find matching message! timestamp: ${editMessage.targetSentTimestamp}  author: ${senderRecipient.id}")

      if (earlyMessageCacheEntry != null) {
        ApplicationDependencies.getEarlyMessageCache().store(senderRecipient.id, editMessage.targetSentTimestamp, earlyMessageCacheEntry)
        PushProcessEarlyMessagesJob.enqueue()
      }

      return
    }

    val message = editMessage.dataMessage
    val isMediaMessage = message.isMediaMessage
    val groupId: GroupId.V2? = message.groupV2.groupId

    val originalMessage = targetMessage.originalMessageId?.let { SignalDatabase.messages.getMessageRecord(it.id) } ?: targetMessage
    val validTiming = MessageConstraintsUtil.isValidEditMessageReceive(originalMessage, senderRecipient, envelope.serverTimestamp)
    val validAuthor = senderRecipient.id == originalMessage.fromRecipient.id
    val validGroup = groupId == targetThreadRecipient.groupId.orNull()
    val validTarget = !originalMessage.isViewOnce && !originalMessage.hasAudio() && !originalMessage.hasSharedContact()

    if (!validTiming || !validAuthor || !validGroup || !validTarget) {
      warn(envelope.timestamp, "[handleEditMessage] Invalid message edit! editTime: ${envelope.serverTimestamp}, targetTime: ${originalMessage.serverTimestamp}, editAuthor: ${senderRecipient.id}, targetAuthor: ${originalMessage.fromRecipient.id}, editThread: ${threadRecipient.id}, targetThread: ${targetThreadRecipient.id}, validity: (timing: $validTiming, author: $validAuthor, group: $validGroup, target: $validTarget)")
      return
    }

    if (groupId != null && MessageContentProcessorV2.handleGv2PreProcessing(context, envelope.timestamp, content, metadata, groupId, message.groupV2, senderRecipient) == MessageContentProcessorV2.Gv2PreProcessResult.IGNORE) {
      warn(envelope.timestamp, "[handleEditMessage] Group processor indicated we should ignore this.")
      return
    }

    DataMessageProcessor.notifyTypingStoppedFromIncomingMessage(context, senderRecipient, threadRecipient.id, metadata.sourceDeviceId)

    targetMessage = targetMessage.withAttachments(context, SignalDatabase.attachments.getAttachmentsForMessage(targetMessage.id))

    val insertResult: InsertResult? = if (isMediaMessage || targetMessage.quote != null || targetMessage.slideDeck.slides.isNotEmpty()) {
      handleEditMediaMessage(senderRecipient.id, groupId, envelope, metadata, message, targetMessage)
    } else {
      handleEditTextMessage(senderRecipient.id, groupId, envelope, metadata, message, targetMessage)
    }

    if (insertResult != null) {
      SignalExecutors.BOUNDED.execute {
        ApplicationDependencies.getJobManager().add(SendDeliveryReceiptJob(senderRecipient.id, message.timestamp, MessageId(insertResult.messageId)))
      }

      if (targetMessage.expireStarted > 0) {
        ApplicationDependencies.getExpiringMessageManager()
          .scheduleDeletion(
            insertResult.messageId,
            true,
            targetMessage.expireStarted,
            targetMessage.expiresIn
          )
      }

      ApplicationDependencies.getMessageNotifier().updateNotification(context, forConversation(insertResult.threadId))
    }
  }

  private fun handleEditMediaMessage(
    senderRecipientId: RecipientId,
    groupId: GroupId.V2?,
    envelope: SignalServiceProtos.Envelope,
    metadata: EnvelopeMetadata,
    message: DataMessage,
    targetMessage: MediaMmsMessageRecord
  ): InsertResult? {
    val messageRanges: BodyRangeList? = message.bodyRangesList.filter { it.hasStyle() }.toList().toBodyRangeList()
    val targetQuote = targetMessage.quote
    val quote: QuoteModel? = if (targetQuote != null && message.hasQuote()) {
      QuoteModel(
        targetQuote.id,
        targetQuote.author,
        targetQuote.displayText.toString(),
        targetQuote.isOriginalMissing,
        emptyList(),
        null,
        targetQuote.quoteType,
        null
      )
    } else {
      null
    }
    val attachments = message.attachmentsList.toPointersWithinLimit()
    attachments.filter {
      MediaUtil.SlideType.LONG_TEXT == MediaUtil.getSlideTypeFromContentType(it.contentType)
    }
    val mediaMessage = IncomingMediaMessage(
      from = senderRecipientId,
      sentTimeMillis = message.timestamp,
      serverTimeMillis = envelope.serverTimestamp,
      receivedTimeMillis = targetMessage.dateReceived,
      expiresIn = targetMessage.expiresIn,
      isViewOnce = message.isViewOnce,
      isUnidentified = metadata.sealedSender,
      body = message.body,
      groupId = groupId,
      attachments = attachments,
      quote = quote,
      sharedContacts = emptyList(),
      linkPreviews = DataMessageProcessor.getLinkPreviews(message.previewList, message.body ?: "", false),
      mentions = DataMessageProcessor.getMentions(message.bodyRangesList),
      serverGuid = envelope.serverGuid,
      messageRanges = messageRanges,
      isPushMessage = true
    )

    return SignalDatabase.messages.insertEditMessageInbox(-1, mediaMessage, targetMessage).orNull()
  }

  private fun handleEditTextMessage(
    senderRecipientId: RecipientId,
    groupId: GroupId.V2?,
    envelope: SignalServiceProtos.Envelope,
    metadata: EnvelopeMetadata,
    message: DataMessage,
    targetMessage: MediaMmsMessageRecord
  ): InsertResult? {
    var textMessage = IncomingTextMessage(
      senderRecipientId,
      metadata.sourceDeviceId,
      envelope.timestamp,
      envelope.timestamp,
      targetMessage.dateReceived,
      message.body,
      Optional.ofNullable(groupId),
      targetMessage.expiresIn,
      metadata.sealedSender,
      envelope.serverGuid
    )

    textMessage = IncomingEncryptedMessage(textMessage, message.body)

    return SignalDatabase.messages.insertEditMessageInbox(textMessage, targetMessage).orNull()
  }
}
