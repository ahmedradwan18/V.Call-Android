package org.variiance.vcall.components.settings.app.wrapped

import androidx.fragment.app.Fragment
import org.variiance.vcall.R
import org.variiance.vcall.preferences.EditProxyFragment

class WrappedEditProxyFragment : SettingsWrapperFragment() {
  override fun getFragment(): Fragment {
    toolbar.setTitle(R.string.preferences_use_proxy)
    return EditProxyFragment()
  }
}
