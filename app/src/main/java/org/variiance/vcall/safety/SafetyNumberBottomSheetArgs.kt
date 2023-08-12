package org.variiance.vcall.safety

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import org.variiance.vcall.contacts.paged.ContactSearchKey
import org.variiance.vcall.database.model.MessageId
import org.variiance.vcall.recipients.RecipientId

/**
 * Fragment argument for `SafetyNumberBottomSheetFragment`
 */
@Parcelize
data class SafetyNumberBottomSheetArgs(
  val untrustedRecipients: List<RecipientId>,
  val destinations: List<ContactSearchKey.RecipientSearchKey>,
  val messageId: MessageId? = null
) : Parcelable
