package org.variiance.vcall.badges.self.expired

import androidx.core.content.ContextCompat
import org.variiance.vcall.R
import org.variiance.vcall.components.settings.DSLConfiguration
import org.variiance.vcall.components.settings.DSLSettingsAdapter
import org.variiance.vcall.components.settings.DSLSettingsBottomSheetFragment
import org.variiance.vcall.components.settings.DSLSettingsText
import org.variiance.vcall.components.settings.configure
import org.variiance.vcall.components.settings.models.SplashImage
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.util.CommunicationActions

class CantProcessSubscriptionPaymentBottomSheetDialogFragment : DSLSettingsBottomSheetFragment() {
  override fun bindAdapter(adapter: DSLSettingsAdapter) {
    SplashImage.register(adapter)
    adapter.submitList(getConfiguration().toMappingModelList())
  }

  private fun getConfiguration(): DSLConfiguration {
    return configure {
      customPref(SplashImage.Model(R.drawable.ic_card_process))

      sectionHeaderPref(
        title = DSLSettingsText.from(R.string.CantProcessSubscriptionPaymentBottomSheetDialogFragment__cant_process_subscription_payment, DSLSettingsText.CenterModifier)
      )

      textPref(
        summary = DSLSettingsText.from(
          requireContext().getString(R.string.CantProcessSubscriptionPaymentBottomSheetDialogFragment__were_having_trouble),
          DSLSettingsText.LearnMoreModifier(ContextCompat.getColor(requireContext(), R.color.signal_accent_primary)) {
            CommunicationActions.openBrowserLink(requireContext(), requireContext().getString(R.string.donation_decline_code_error_url))
          },
          DSLSettingsText.CenterModifier
        )
      )

      primaryButton(
        text = DSLSettingsText.from(android.R.string.ok)
      ) {
        dismissAllowingStateLoss()
      }

      secondaryButtonNoOutline(
        text = DSLSettingsText.from(R.string.CantProcessSubscriptionPaymentBottomSheetDialogFragment__dont_show_this_again)
      ) {
        SignalStore.donationsValues().showCantProcessDialog = false
        dismissAllowingStateLoss()
      }
    }
  }
}
