package org.variiance.vcall.database.model

import org.variiance.vcall.recipients.RecipientId

/** A model for [org.variiance.vcall.database.PendingRetryReceiptTable] */
data class PendingRetryReceiptModel(
  val id: Long,
  val author: RecipientId,
  val authorDevice: Int,
  val sentTimestamp: Long,
  val receivedTimestamp: Long,
  val threadId: Long
)
