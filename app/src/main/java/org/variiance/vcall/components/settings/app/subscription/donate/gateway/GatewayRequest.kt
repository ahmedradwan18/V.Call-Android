package org.variiance.vcall.components.settings.app.subscription.donate.gateway

import android.os.Parcelable
import kotlinx.parcelize.IgnoredOnParcel
import kotlinx.parcelize.Parcelize
import org.signal.core.util.money.FiatMoney
import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.components.settings.app.subscription.donate.DonateToSignalType
import org.variiance.vcall.recipients.RecipientId
import java.math.BigDecimal
import java.util.Currency

@Parcelize
data class GatewayRequest(
  val donateToSignalType: DonateToSignalType,
  val badge: Badge,
  val label: String,
  val price: BigDecimal,
  val currencyCode: String,
  val level: Long,
  val recipientId: RecipientId,
  val additionalMessage: String? = null
) : Parcelable {
  @IgnoredOnParcel
  val fiat: FiatMoney = FiatMoney(price, Currency.getInstance(currencyCode))
}
