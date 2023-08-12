package org.variiance.vcall.components.settings.app.wrapped

import androidx.fragment.app.Fragment
import org.variiance.vcall.R
import org.variiance.vcall.preferences.AdvancedPinPreferenceFragment

class WrappedAdvancedPinPreferenceFragment : SettingsWrapperFragment() {
  override fun getFragment(): Fragment {
    toolbar.setTitle(R.string.preferences__advanced_pin_settings)
    return AdvancedPinPreferenceFragment()
  }
}
