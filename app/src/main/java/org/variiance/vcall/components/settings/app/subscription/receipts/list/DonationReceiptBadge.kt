package org.variiance.vcall.components.settings.app.subscription.receipts.list

import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.database.model.DonationReceiptRecord

data class DonationReceiptBadge(
  val type: DonationReceiptRecord.Type,
  val level: Int,
  val badge: Badge
)
