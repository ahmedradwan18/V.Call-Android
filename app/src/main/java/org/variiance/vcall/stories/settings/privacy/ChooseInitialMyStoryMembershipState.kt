package org.variiance.vcall.stories.settings.privacy

import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.stories.settings.my.MyStoryPrivacyState

data class ChooseInitialMyStoryMembershipState(
  val recipientId: RecipientId? = null,
  val privacyState: MyStoryPrivacyState = MyStoryPrivacyState(),
  val allSignalConnectionsCount: Int = 0,
  val hasUserPerformedManualSelection: Boolean = false
)
