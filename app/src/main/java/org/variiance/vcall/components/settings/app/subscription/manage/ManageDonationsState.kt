package org.variiance.vcall.components.settings.app.subscription.manage

import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.subscription.Subscription
import org.whispersystems.signalservice.api.subscriptions.ActiveSubscription

data class ManageDonationsState(
  val hasOneTimeBadge: Boolean = false,
  val hasReceipts: Boolean = false,
  val featuredBadge: Badge? = null,
  val transactionState: TransactionState = TransactionState.Init,
  val availableSubscriptions: List<Subscription> = emptyList(),
  private val subscriptionRedemptionState: SubscriptionRedemptionState = SubscriptionRedemptionState.NONE
) {

  fun getMonthlyDonorRedemptionState(): SubscriptionRedemptionState {
    return when (transactionState) {
      TransactionState.Init -> subscriptionRedemptionState
      TransactionState.NetworkFailure -> subscriptionRedemptionState
      TransactionState.InTransaction -> SubscriptionRedemptionState.IN_PROGRESS
      is TransactionState.NotInTransaction -> getStateFromActiveSubscription(transactionState.activeSubscription) ?: subscriptionRedemptionState
    }
  }

  private fun getStateFromActiveSubscription(activeSubscription: ActiveSubscription): SubscriptionRedemptionState? {
    return when {
      activeSubscription.isFailedPayment -> SubscriptionRedemptionState.FAILED
      activeSubscription.isInProgress -> SubscriptionRedemptionState.IN_PROGRESS
      else -> null
    }
  }

  sealed class TransactionState {
    object Init : TransactionState()
    object NetworkFailure : TransactionState()
    object InTransaction : TransactionState()
    class NotInTransaction(val activeSubscription: ActiveSubscription) : TransactionState()
  }

  enum class SubscriptionRedemptionState {
    NONE,
    IN_PROGRESS,
    FAILED
  }
}
