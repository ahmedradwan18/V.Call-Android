package org.variiance.vcall.profiles.manage

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import org.variiance.vcall.R
import org.variiance.vcall.components.ViewBinderDelegate
import org.variiance.vcall.databinding.UsernameEducationFragmentBinding
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.megaphone.Megaphones
import org.variiance.vcall.util.CommunicationActions
import org.variiance.vcall.util.navigation.safeNavigate

/**
 * Displays a Username education screen which displays some basic information
 * about usernames and provides a learn-more link.
 */
class UsernameEducationFragment : Fragment(R.layout.username_education_fragment) {
  private val binding by ViewBinderDelegate(UsernameEducationFragmentBinding::bind)

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    binding.toolbar.setNavigationOnClickListener {
      findNavController().popBackStack()
    }

    binding.usernameEducationLearnMore.setOnClickListener {
      CommunicationActions.openBrowserLink(requireContext(), getString(R.string.username_support_url))
    }

    binding.continueButton.setOnClickListener {
      SignalStore.uiHints().markHasSeenUsernameEducation()
      ApplicationDependencies.getMegaphoneRepository().markFinished(Megaphones.Event.SET_UP_YOUR_USERNAME)
      findNavController().safeNavigate(UsernameEducationFragmentDirections.actionUsernameEducationFragmentToUsernameManageFragment())
    }
  }
}
