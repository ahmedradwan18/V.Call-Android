package org.variiance.vcall.mms

import org.variiance.vcall.attachments.Attachment
import org.variiance.vcall.database.model.Mention
import org.variiance.vcall.database.model.databaseprotos.BodyRangeList
import org.variiance.vcall.recipients.RecipientId
import org.whispersystems.signalservice.api.messages.SignalServiceDataMessage
import org.whispersystems.signalservice.internal.push.SignalServiceProtos

class QuoteModel(
  val id: Long,
  val author: RecipientId,
  val text: String,
  val isOriginalMissing: Boolean,
  val attachments: List<Attachment>,
  mentions: List<Mention>?,
  val type: Type,
  val bodyRanges: BodyRangeList?
) {
  val mentions: List<Mention>

  init {
    this.mentions = mentions ?: emptyList()
  }

  enum class Type(val code: Int, val dataMessageType: SignalServiceDataMessage.Quote.Type) {

    NORMAL(0, SignalServiceDataMessage.Quote.Type.NORMAL),
    GIFT_BADGE(1, SignalServiceDataMessage.Quote.Type.GIFT_BADGE);

    companion object {
      @JvmStatic
      fun fromCode(code: Int): Type {
        for (value in values()) {
          if (value.code == code) {
            return value
          }
        }
        throw IllegalArgumentException("Invalid code: $code")
      }

      @JvmStatic
      fun fromDataMessageType(dataMessageType: SignalServiceDataMessage.Quote.Type): Type {
        for (value in values()) {
          if (value.dataMessageType === dataMessageType) {
            return value
          }
        }
        return NORMAL
      }

      fun fromProto(type: SignalServiceProtos.DataMessage.Quote.Type): Type {
        return if (type == SignalServiceProtos.DataMessage.Quote.Type.GIFT_BADGE) {
          GIFT_BADGE
        } else {
          NORMAL
        }
      }
    }
  }
}
