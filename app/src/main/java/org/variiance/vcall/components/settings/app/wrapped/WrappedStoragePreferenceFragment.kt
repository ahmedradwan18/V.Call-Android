package org.variiance.vcall.components.settings.app.wrapped

import androidx.fragment.app.Fragment
import org.variiance.vcall.preferences.StoragePreferenceFragment

class WrappedStoragePreferenceFragment : SettingsWrapperFragment() {
  override fun getFragment(): Fragment {
    return StoragePreferenceFragment()
  }
}
