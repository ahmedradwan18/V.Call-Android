package org.variiance.vcall.exporter.flow

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.disposables.Disposable
import org.signal.smsexporter.DefaultSmsHelper
import org.signal.smsexporter.SmsExportProgress
import org.signal.smsexporter.SmsExportService
import org.variiance.vcall.R
import org.variiance.vcall.databinding.ExportYourSmsMessagesFragmentBinding
import org.variiance.vcall.util.Material3OnScrollHelper
import org.variiance.vcall.util.navigation.safeNavigate

/**
 * "Welcome" screen for exporting sms
 */
class ExportYourSmsMessagesFragment : Fragment(R.layout.export_your_sms_messages_fragment) {

  private var navigationDisposable = Disposable.disposed()

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    val binding = ExportYourSmsMessagesFragmentBinding.bind(view)

    binding.toolbar.setOnClickListener {
      requireActivity().finish()
    }

    binding.continueButton.setOnClickListener {
      if (DefaultSmsHelper.isDefaultSms(requireContext())) {
        findNavController().safeNavigate(ExportYourSmsMessagesFragmentDirections.actionExportYourSmsMessagesFragmentToExportingSmsMessagesFragment())
      } else {
        findNavController().safeNavigate(ExportYourSmsMessagesFragmentDirections.actionExportYourSmsMessagesFragmentToSetSignalAsDefaultSmsAppFragment())
      }
    }

    Material3OnScrollHelper(requireActivity(), binding.toolbar, viewLifecycleOwner).attach(binding.scrollView)
  }

  override fun onResume() {
    super.onResume()
    navigationDisposable = SmsExportService
      .progressState
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe {
        if (it !is SmsExportProgress.Init) {
          findNavController().safeNavigate(ExportYourSmsMessagesFragmentDirections.actionExportYourSmsMessagesFragmentToExportingSmsMessagesFragment())
        }
      }
  }

  override fun onPause() {
    super.onPause()
    navigationDisposable.dispose()
  }
}
