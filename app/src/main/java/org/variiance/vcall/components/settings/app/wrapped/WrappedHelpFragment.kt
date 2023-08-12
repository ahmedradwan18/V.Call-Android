package org.variiance.vcall.components.settings.app.wrapped

import androidx.fragment.app.Fragment
import org.variiance.vcall.R
import org.variiance.vcall.help.HelpFragment

class WrappedHelpFragment : SettingsWrapperFragment() {
  override fun getFragment(): Fragment {
    toolbar.title = getString(R.string.preferences__help)

    val fragment = HelpFragment()
    fragment.arguments = arguments

    return fragment
  }
}
