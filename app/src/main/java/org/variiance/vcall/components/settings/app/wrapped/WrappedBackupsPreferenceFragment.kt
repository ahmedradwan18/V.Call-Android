package org.variiance.vcall.components.settings.app.wrapped

import androidx.fragment.app.Fragment
import org.variiance.vcall.R
import org.variiance.vcall.preferences.BackupsPreferenceFragment

class WrappedBackupsPreferenceFragment : SettingsWrapperFragment() {
  override fun getFragment(): Fragment {
    toolbar.setTitle(R.string.BackupsPreferenceFragment__chat_backups)
    return BackupsPreferenceFragment()
  }
}
