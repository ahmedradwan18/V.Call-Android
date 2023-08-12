package org.variiance.vcall.badges.gifts.viewgift.sent

import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.recipients.Recipient

data class ViewSentGiftState(
  val recipient: Recipient? = null,
  val badge: Badge? = null
)
