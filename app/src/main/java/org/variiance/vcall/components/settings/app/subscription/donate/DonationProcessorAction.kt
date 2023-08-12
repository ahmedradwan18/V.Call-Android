package org.variiance.vcall.components.settings.app.subscription.donate

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
enum class DonationProcessorAction : Parcelable {
  PROCESS_NEW_DONATION,
  UPDATE_SUBSCRIPTION,
  CANCEL_SUBSCRIPTION
}
