package org.variiance.vcall.mms

import org.variiance.vcall.attachments.Attachment
import org.variiance.vcall.attachments.PointerAttachment
import org.variiance.vcall.contactshare.Contact
import org.variiance.vcall.database.model.Mention
import org.variiance.vcall.database.model.ParentStoryId
import org.variiance.vcall.database.model.StoryType
import org.variiance.vcall.database.model.databaseprotos.BodyRangeList
import org.variiance.vcall.database.model.databaseprotos.GiftBadge
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.linkpreview.LinkPreview
import org.variiance.vcall.recipients.RecipientId
import org.whispersystems.signalservice.api.messages.SignalServiceAttachment
import org.whispersystems.signalservice.api.messages.SignalServiceContent
import org.whispersystems.signalservice.api.messages.SignalServiceGroupV2
import java.util.Optional
import java.util.UUID

class IncomingMediaMessage(
  val from: RecipientId?,
  val groupId: GroupId? = null,
  val body: String? = null,
  val isPushMessage: Boolean = false,
  val storyType: StoryType = StoryType.NONE,
  val parentStoryId: ParentStoryId? = null,
  val isStoryReaction: Boolean = false,
  val sentTimeMillis: Long,
  val serverTimeMillis: Long,
  val receivedTimeMillis: Long,
  val subscriptionId: Int = -1,
  val expiresIn: Long = 0,
  val isExpirationUpdate: Boolean = false,
  val quote: QuoteModel? = null,
  val isUnidentified: Boolean = false,
  val isViewOnce: Boolean = false,
  val serverGuid: String? = null,
  val messageRanges: BodyRangeList? = null,
  attachments: List<Attachment> = emptyList(),
  sharedContacts: List<Contact> = emptyList(),
  linkPreviews: List<LinkPreview> = emptyList(),
  mentions: List<Mention> = emptyList(),
  val giftBadge: GiftBadge? = null,
  val isPaymentsNotification: Boolean = false,
  val isActivatePaymentsRequest: Boolean = false,
  val isPaymentsActivated: Boolean = false
) {

  val attachments: List<Attachment> = ArrayList(attachments)
  val sharedContacts: List<Contact> = ArrayList(sharedContacts)
  val linkPreviews: List<LinkPreview> = ArrayList(linkPreviews)
  val mentions: List<Mention> = ArrayList(mentions)

  val isGroupMessage: Boolean = groupId != null

  constructor(
    from: RecipientId?,
    groupId: Optional<GroupId>,
    body: String?,
    sentTimeMillis: Long,
    serverTimeMillis: Long,
    receivedTimeMillis: Long,
    attachments: List<Attachment>?,
    subscriptionId: Int,
    expiresIn: Long,
    expirationUpdate: Boolean,
    viewOnce: Boolean,
    unidentified: Boolean,
    sharedContacts: Optional<List<Contact>>,
    activatePaymentsRequest: Boolean,
    paymentsActivated: Boolean
  ) : this(
    from = from,
    groupId = groupId.orElse(null),
    body = body,
    isPushMessage = false,
    sentTimeMillis = sentTimeMillis,
    serverTimeMillis = serverTimeMillis,
    receivedTimeMillis = receivedTimeMillis,
    subscriptionId = subscriptionId,
    expiresIn = expiresIn,
    isExpirationUpdate = expirationUpdate,
    quote = null,
    isUnidentified = unidentified,
    isViewOnce = viewOnce,
    serverGuid = null,
    attachments = attachments?.let { ArrayList<Attachment>(it) } ?: emptyList(),
    sharedContacts = ArrayList<Contact>(sharedContacts.orElse(emptyList())),
    isActivatePaymentsRequest = activatePaymentsRequest,
    isPaymentsActivated = paymentsActivated
  )

  @JvmOverloads
  constructor(
    from: RecipientId?,
    sentTimeMillis: Long,
    serverTimeMillis: Long,
    receivedTimeMillis: Long,
    storyType: StoryType,
    parentStoryId: ParentStoryId?,
    isStoryReaction: Boolean,
    subscriptionId: Int,
    expiresIn: Long,
    expirationUpdate: Boolean,
    viewOnce: Boolean,
    unidentified: Boolean,
    body: Optional<String>,
    group: Optional<SignalServiceGroupV2>,
    attachments: Optional<List<SignalServiceAttachment>>,
    quote: Optional<QuoteModel>,
    sharedContacts: Optional<List<Contact>>,
    linkPreviews: Optional<List<LinkPreview>>,
    mentions: Optional<List<Mention>>,
    sticker: Optional<Attachment>,
    serverGuid: String?,
    giftBadge: GiftBadge?,
    activatePaymentsRequest: Boolean,
    paymentsActivated: Boolean,
    messageRanges: BodyRangeList? = null
  ) : this(
    from = from,
    groupId = if (group.isPresent) GroupId.v2(group.get().masterKey) else null,
    body = body.orElse(null),
    isPushMessage = true,
    storyType = storyType,
    parentStoryId = parentStoryId,
    isStoryReaction = isStoryReaction,
    sentTimeMillis = sentTimeMillis,
    serverTimeMillis = serverTimeMillis,
    receivedTimeMillis = receivedTimeMillis,
    subscriptionId = subscriptionId,
    expiresIn = expiresIn,
    isExpirationUpdate = expirationUpdate,
    quote = quote.orElse(null),
    isUnidentified = unidentified,
    isViewOnce = viewOnce,
    serverGuid = serverGuid,
    attachments = PointerAttachment.forPointers(attachments).apply { if (sticker.isPresent) add(sticker.get()) },
    sharedContacts = sharedContacts.orElse(emptyList()),
    linkPreviews = linkPreviews.orElse(emptyList()),
    mentions = mentions.orElse(emptyList()),
    giftBadge = giftBadge,
    isActivatePaymentsRequest = activatePaymentsRequest,
    isPaymentsActivated = paymentsActivated,
    messageRanges = messageRanges
  )

  companion object {
    @JvmStatic
    fun createIncomingPaymentNotification(
      from: RecipientId,
      content: SignalServiceContent,
      receivedTime: Long,
      expiresIn: Long,
      paymentUuid: UUID
    ): IncomingMediaMessage {
      return IncomingMediaMessage(
        from = from,
        body = paymentUuid.toString(),
        sentTimeMillis = content.timestamp,
        serverTimeMillis = content.serverReceivedTimestamp,
        receivedTimeMillis = receivedTime,
        expiresIn = expiresIn,
        isUnidentified = content.isNeedsReceipt,
        serverGuid = content.serverUuid,
        isPushMessage = true,
        isPaymentsNotification = true
      )
    }
  }
}
