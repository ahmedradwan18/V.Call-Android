package org.variiance.vcall.exporter.flow

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import org.variiance.vcall.R
import org.variiance.vcall.SmsExportDirections
import org.variiance.vcall.databinding.ExportSmsCompleteFragmentBinding
import org.variiance.vcall.util.navigation.safeNavigate

/**
 * Shown when export sms completes.
 */
class ExportSmsCompleteFragment : Fragment(R.layout.export_sms_complete_fragment) {

  private val args: ExportSmsCompleteFragmentArgs by navArgs()

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    val exportSuccessCount = args.exportMessageCount - args.exportMessageFailureCount

    val binding = ExportSmsCompleteFragmentBinding.bind(view)
    binding.exportCompleteNext.setOnClickListener { findNavController().safeNavigate(SmsExportDirections.actionDirectToChooseANewDefaultSmsAppFragment()) }
    binding.exportCompleteStatus.text = resources.getQuantityString(R.plurals.ExportSmsCompleteFragment__d_of_d_messages_exported, args.exportMessageCount, exportSuccessCount, args.exportMessageCount)
  }
}
