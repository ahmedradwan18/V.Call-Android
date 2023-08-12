package org.variiance.vcall.components.settings.app.privacy.pnp

import org.variiance.vcall.keyvalue.PhoneNumberPrivacyValues

data class PhoneNumberPrivacySettingsState(
  val seeMyPhoneNumber: PhoneNumberPrivacyValues.PhoneNumberSharingMode,
  val findMeByPhoneNumber: PhoneNumberPrivacyValues.PhoneNumberListingMode
)
