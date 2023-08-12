package org.variiance.vcall.profiles.edit.pnp

import io.reactivex.rxjava3.core.Completable
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobs.RefreshAttributesJob
import org.variiance.vcall.keyvalue.PhoneNumberPrivacyValues
import org.variiance.vcall.keyvalue.SignalStore

/**
 * Manages the current phone-number listing state.
 */
class WhoCanSeeMyPhoneNumberRepository {

  fun getCurrentState(): WhoCanSeeMyPhoneNumberState {
    return when (SignalStore.phoneNumberPrivacy().phoneNumberListingMode) {
      PhoneNumberPrivacyValues.PhoneNumberListingMode.LISTED -> WhoCanSeeMyPhoneNumberState.EVERYONE
      PhoneNumberPrivacyValues.PhoneNumberListingMode.UNLISTED -> WhoCanSeeMyPhoneNumberState.NOBODY
    }
  }

  fun onSave(whoCanSeeMyPhoneNumberState: WhoCanSeeMyPhoneNumberState): Completable {
    return Completable.fromAction {
      SignalStore.phoneNumberPrivacy().phoneNumberListingMode = when (whoCanSeeMyPhoneNumberState) {
        WhoCanSeeMyPhoneNumberState.EVERYONE -> PhoneNumberPrivacyValues.PhoneNumberListingMode.LISTED
        WhoCanSeeMyPhoneNumberState.NOBODY -> PhoneNumberPrivacyValues.PhoneNumberListingMode.UNLISTED
      }

      ApplicationDependencies.getJobManager().add(RefreshAttributesJob())
    }
  }
}
