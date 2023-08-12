package org.variiance.vcall.components.settings.app.subscription.donate.card

import org.signal.core.util.dp
import org.variiance.vcall.R
import org.variiance.vcall.components.settings.DSLConfiguration
import org.variiance.vcall.components.settings.DSLSettingsAdapter
import org.variiance.vcall.components.settings.DSLSettingsBottomSheetFragment
import org.variiance.vcall.components.settings.DSLSettingsText
import org.variiance.vcall.components.settings.configure

/**
 * Displays information about how Signal keeps card details private and how
 * Signal does not link donation information to your Signal account.
 */
class YourInformationIsPrivateBottomSheet : DSLSettingsBottomSheetFragment() {
  override fun bindAdapter(adapter: DSLSettingsAdapter) {
    adapter.submitList(getConfiguration().toMappingModelList())
  }

  private fun getConfiguration(): DSLConfiguration {
    return configure {
      space(10.dp)

      noPadTextPref(
        title = DSLSettingsText.from(
          R.string.YourInformationIsPrivateBottomSheet__your_information_is_private,
          DSLSettingsText.CenterModifier,
          DSLSettingsText.TextAppearanceModifier(R.style.Signal_Text_HeadlineMedium)
        )
      )

      space(24.dp)

      noPadTextPref(
        title = DSLSettingsText.from(
          R.string.YourInformationIsPrivateBottomSheet__signal_does_not_collect,
          DSLSettingsText.BodyLargeModifier
        )
      )

      space(24.dp)

      noPadTextPref(
        title = DSLSettingsText.from(
          R.string.YourInformationIsPrivateBottomSheet__we_use_stripe,
          DSLSettingsText.BodyLargeModifier
        )
      )

      space(24.dp)

      noPadTextPref(
        title = DSLSettingsText.from(
          R.string.YourInformationIsPrivateBottomSheet__signal_does_not_and_cannot,
          DSLSettingsText.BodyLargeModifier
        )
      )

      space(24.dp)

      noPadTextPref(
        title = DSLSettingsText.from(
          R.string.YourInformationIsPrivateBottomSheet__thank_you,
          DSLSettingsText.BodyLargeModifier
        )
      )

      space(56.dp)
    }
  }
}
