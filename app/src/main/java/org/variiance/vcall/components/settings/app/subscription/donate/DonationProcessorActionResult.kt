package org.variiance.vcall.components.settings.app.subscription.donate

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import org.variiance.vcall.components.settings.app.subscription.donate.gateway.GatewayRequest

@Parcelize
class DonationProcessorActionResult(
  val action: DonationProcessorAction,
  val request: GatewayRequest,
  val status: Status
) : Parcelable {
  enum class Status {
    SUCCESS,
    FAILURE
  }
}
