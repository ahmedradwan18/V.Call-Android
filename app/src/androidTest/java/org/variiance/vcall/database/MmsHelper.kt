package org.variiance.vcall.database

import org.variiance.vcall.database.model.ParentStoryId
import org.variiance.vcall.database.model.StoryType
import org.variiance.vcall.database.model.databaseprotos.GiftBadge
import org.variiance.vcall.mms.IncomingMediaMessage
import org.variiance.vcall.mms.OutgoingMessage
import org.variiance.vcall.recipients.Recipient
import java.util.Optional

/**
 * Helper methods for inserting an MMS message into the MMS table.
 */
object MmsHelper {

  fun insert(
    recipient: Recipient = Recipient.UNKNOWN,
    body: String = "body",
    sentTimeMillis: Long = System.currentTimeMillis(),
    subscriptionId: Int = -1,
    expiresIn: Long = 0,
    viewOnce: Boolean = false,
    distributionType: Int = ThreadTable.DistributionTypes.DEFAULT,
    threadId: Long = SignalDatabase.threads.getOrCreateThreadIdFor(recipient, distributionType),
    storyType: StoryType = StoryType.NONE,
    parentStoryId: ParentStoryId? = null,
    isStoryReaction: Boolean = false,
    giftBadge: GiftBadge? = null,
    secure: Boolean = true
  ): Long {
    val message = OutgoingMessage(
      recipient = recipient,
      body = body,
      timestamp = sentTimeMillis,
      subscriptionId = subscriptionId,
      expiresIn = expiresIn,
      viewOnce = viewOnce,
      distributionType = distributionType,
      storyType = storyType,
      parentStoryId = parentStoryId,
      isStoryReaction = isStoryReaction,
      giftBadge = giftBadge,
      isSecure = secure
    )

    return insert(
      message = message,
      threadId = threadId
    )
  }

  fun insert(
    message: OutgoingMessage,
    threadId: Long
  ): Long {
    return SignalDatabase.messages.insertMessageOutbox(message, threadId, false, GroupReceiptTable.STATUS_UNKNOWN, null)
  }

  fun insert(
    message: IncomingMediaMessage,
    threadId: Long
  ): Optional<MessageTable.InsertResult> {
    return SignalDatabase.messages.insertSecureDecryptedMessageInbox(message, threadId)
  }
}
