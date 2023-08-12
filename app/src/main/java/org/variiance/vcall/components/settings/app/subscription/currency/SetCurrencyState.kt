package org.variiance.vcall.components.settings.app.subscription.currency

import java.util.Currency

data class SetCurrencyState(
  val selectedCurrencyCode: String = "",
  val currencies: List<Currency> = listOf()
)
