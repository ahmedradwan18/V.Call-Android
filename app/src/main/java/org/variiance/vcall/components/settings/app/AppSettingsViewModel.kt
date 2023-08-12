package org.variiance.vcall.components.settings.app

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import io.reactivex.rxjava3.disposables.CompositeDisposable
import io.reactivex.rxjava3.kotlin.plusAssign
import io.reactivex.rxjava3.kotlin.subscribeBy
import org.variiance.vcall.components.settings.app.subscription.InAppDonations
import org.variiance.vcall.components.settings.app.subscription.MonthlyDonationRepository
import org.variiance.vcall.conversationlist.model.UnreadPaymentsLiveData
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.util.TextSecurePreferences
import org.variiance.vcall.util.livedata.Store

class AppSettingsViewModel(
  monthlyDonationRepository: MonthlyDonationRepository = MonthlyDonationRepository(ApplicationDependencies.getDonationsService())
) : ViewModel() {

  private val store = Store(
    AppSettingsState(
      Recipient.self(),
      0,
      SignalStore.donationsValues().getExpiredGiftBadge() != null,
      SignalStore.donationsValues().isLikelyASustainer() || InAppDonations.hasAtLeastOnePaymentMethodAvailable(),
      TextSecurePreferences.isUnauthorizedReceived(ApplicationDependencies.getApplication()),
      SignalStore.misc().isClientDeprecated
    )
  )

  private val unreadPaymentsLiveData = UnreadPaymentsLiveData()
  private val selfLiveData: LiveData<Recipient> = Recipient.self().live().liveData
  private val disposables = CompositeDisposable()

  val state: LiveData<AppSettingsState> = store.stateLiveData

  init {
    store.update(unreadPaymentsLiveData) { payments, state -> state.copy(unreadPaymentsCount = payments.map { it.unreadCount }.orElse(0)) }
    store.update(selfLiveData) { self, state -> state.copy(self = self) }

    disposables += monthlyDonationRepository.getActiveSubscription().subscribeBy(
      onSuccess = { activeSubscription ->
        store.update { state ->
          state.copy(allowUserToGoToDonationManagementScreen = activeSubscription.isActive || InAppDonations.hasAtLeastOnePaymentMethodAvailable())
        }
      },
      onError = {}
    )
  }

  override fun onCleared() {
    disposables.clear()
  }

  fun refreshDeprecatedOrUnregistered() {
    store.update { it.copy(clientDeprecated = SignalStore.misc().isClientDeprecated, userUnregistered = TextSecurePreferences.isUnauthorizedReceived(ApplicationDependencies.getApplication())) }
  }

  fun refreshExpiredGiftBadge() {
    store.update { it.copy(hasExpiredGiftBadge = SignalStore.donationsValues().getExpiredGiftBadge() != null) }
  }
}
