package org.variiance.vcall.components.settings.app.internal.donor

import org.signal.donations.StripeDeclineCode
import org.variiance.vcall.badges.models.Badge
import org.variiance.vcall.components.settings.app.subscription.errors.UnexpectedSubscriptionCancellation

data class InternalDonorErrorConfigurationState(
  val badges: List<Badge> = emptyList(),
  val selectedBadge: Badge? = null,
  val selectedUnexpectedSubscriptionCancellation: UnexpectedSubscriptionCancellation? = null,
  val selectedStripeDeclineCode: StripeDeclineCode.Code? = null
)
