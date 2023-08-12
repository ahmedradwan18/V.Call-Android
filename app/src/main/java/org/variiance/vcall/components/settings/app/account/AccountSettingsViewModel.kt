package org.variiance.vcall.components.settings.app.account

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.util.TextSecurePreferences
import org.variiance.vcall.util.livedata.Store

class AccountSettingsViewModel : ViewModel() {
  private val store: Store<AccountSettingsState> = Store(getCurrentState())

  val state: LiveData<AccountSettingsState> = store.stateLiveData

  fun refreshState() {
    store.update { getCurrentState() }
  }

  private fun getCurrentState(): AccountSettingsState {
    return AccountSettingsState(
      hasPin = SignalStore.svr().hasPin() && !SignalStore.svr().hasOptedOut(),
      pinRemindersEnabled = SignalStore.pinValues().arePinRemindersEnabled(),
      registrationLockEnabled = SignalStore.svr().isRegistrationLockEnabled,
      userUnregistered = TextSecurePreferences.isUnauthorizedReceived(ApplicationDependencies.getApplication()),
      clientDeprecated = SignalStore.misc().isClientDeprecated
    )
  }
}
