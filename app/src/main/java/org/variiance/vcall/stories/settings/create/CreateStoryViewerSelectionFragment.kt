package org.variiance.vcall.stories.settings.create

import androidx.navigation.fragment.findNavController
import org.variiance.vcall.R
import org.variiance.vcall.database.model.DistributionListId
import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.stories.settings.select.BaseStoryRecipientSelectionFragment
import org.variiance.vcall.util.navigation.safeNavigate

/**
 * Allows user to select who will see the story they are creating
 */
class CreateStoryViewerSelectionFragment : BaseStoryRecipientSelectionFragment() {
  override val actionButtonLabel: Int = R.string.CreateStoryViewerSelectionFragment__next
  override val distributionListId: DistributionListId? = null

  override fun goToNextScreen(recipients: Set<RecipientId>) {
    findNavController().safeNavigate(CreateStoryViewerSelectionFragmentDirections.actionCreateStoryViewerSelectionToCreateStoryWithViewers(recipients.toTypedArray()))
  }
}
