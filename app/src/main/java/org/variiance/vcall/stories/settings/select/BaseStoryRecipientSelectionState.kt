package org.variiance.vcall.stories.settings.select

import org.variiance.vcall.database.model.DistributionListId
import org.variiance.vcall.database.model.DistributionListRecord
import org.variiance.vcall.recipients.RecipientId

data class BaseStoryRecipientSelectionState(
  val distributionListId: DistributionListId?,
  val privateStory: DistributionListRecord? = null,
  val selection: Set<RecipientId> = emptySet()
)
