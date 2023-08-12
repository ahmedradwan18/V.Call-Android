package org.variiance.vcall.components.settings.app.subscription.receipts.list

import org.variiance.vcall.database.model.DonationReceiptRecord

data class DonationReceiptListPageState(
  val records: List<DonationReceiptRecord> = emptyList(),
  val isLoaded: Boolean = false
)
