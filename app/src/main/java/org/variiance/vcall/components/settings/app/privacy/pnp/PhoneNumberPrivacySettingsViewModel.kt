package org.variiance.vcall.components.settings.app.privacy.pnp

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobs.RefreshAttributesJob
import org.variiance.vcall.jobs.RefreshOwnProfileJob
import org.variiance.vcall.keyvalue.PhoneNumberPrivacyValues.PhoneNumberListingMode
import org.variiance.vcall.keyvalue.PhoneNumberPrivacyValues.PhoneNumberSharingMode
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.storage.StorageSyncHelper

class PhoneNumberPrivacySettingsViewModel : ViewModel() {

  private val _state = mutableStateOf(
    PhoneNumberPrivacySettingsState(
      seeMyPhoneNumber = SignalStore.phoneNumberPrivacy().phoneNumberSharingMode,
      findMeByPhoneNumber = SignalStore.phoneNumberPrivacy().phoneNumberListingMode
    )
  )

  val state: State<PhoneNumberPrivacySettingsState> = _state

  fun setNobodyCanSeeMyNumber() {
    setPhoneNumberSharingMode(PhoneNumberSharingMode.NOBODY)
  }

  fun setEveryoneCanSeeMyNumber() {
    setPhoneNumberSharingMode(PhoneNumberSharingMode.EVERYONE)
    setPhoneNumberListingMode(PhoneNumberListingMode.LISTED)
  }

  fun setNobodyCanFindMeByMyNumber() {
    setPhoneNumberListingMode(PhoneNumberListingMode.UNLISTED)
  }

  fun setEveryoneCanFindMeByMyNumber() {
    setPhoneNumberListingMode(PhoneNumberListingMode.LISTED)
  }

  private fun setPhoneNumberSharingMode(phoneNumberSharingMode: PhoneNumberSharingMode) {
    SignalStore.phoneNumberPrivacy().phoneNumberSharingMode = phoneNumberSharingMode
    SignalDatabase.recipients.markNeedsSync(Recipient.self().id)
    StorageSyncHelper.scheduleSyncForDataChange()
    refresh()
  }

  private fun setPhoneNumberListingMode(phoneNumberListingMode: PhoneNumberListingMode) {
    SignalStore.phoneNumberPrivacy().phoneNumberListingMode = phoneNumberListingMode
    StorageSyncHelper.scheduleSyncForDataChange()
    ApplicationDependencies.getJobManager().startChain(RefreshAttributesJob()).then(RefreshOwnProfileJob()).enqueue()
    refresh()
  }

  fun refresh() {
    _state.value = PhoneNumberPrivacySettingsState(
      seeMyPhoneNumber = SignalStore.phoneNumberPrivacy().phoneNumberSharingMode,
      findMeByPhoneNumber = SignalStore.phoneNumberPrivacy().phoneNumberListingMode
    )
  }
}
