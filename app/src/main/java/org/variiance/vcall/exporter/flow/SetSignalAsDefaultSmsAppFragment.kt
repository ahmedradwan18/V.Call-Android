package org.variiance.vcall.exporter.flow

import android.os.Bundle
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import org.signal.smsexporter.BecomeSmsAppFailure
import org.signal.smsexporter.DefaultSmsHelper
import org.variiance.vcall.R
import org.variiance.vcall.databinding.SetSignalAsDefaultSmsAppFragmentBinding
import org.variiance.vcall.util.navigation.safeNavigate

class SetSignalAsDefaultSmsAppFragment : Fragment(R.layout.set_signal_as_default_sms_app_fragment) {

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    val binding = SetSignalAsDefaultSmsAppFragmentBinding.bind(view)

    val smsDefaultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
      if (DefaultSmsHelper.isDefaultSms(requireContext())) {
        navigateToExporter()
      }
    }

    binding.continueButton.setOnClickListener {
      DefaultSmsHelper.becomeDefaultSms(requireContext()).either(
        onSuccess = {
          smsDefaultLauncher.launch(it)
        },
        onFailure = {
          when (it) {
            BecomeSmsAppFailure.ALREADY_DEFAULT_SMS -> navigateToExporter()
            BecomeSmsAppFailure.ROLE_IS_NOT_AVAILABLE -> error("Should never happen")
          }
        }
      )
    }
  }

  private fun navigateToExporter() {
    findNavController().safeNavigate(SetSignalAsDefaultSmsAppFragmentDirections.actionSetSignalAsDefaultSmsAppFragmentToExportingSmsMessagesFragment())
  }
}
