package org.variiance.vcall.components.settings.app.usernamelinks.main

import org.variiance.vcall.components.settings.app.usernamelinks.QrCodeData
import org.variiance.vcall.components.settings.app.usernamelinks.UsernameQrCodeColorScheme

/**
 * Represents the UI state of the [UsernameLinkSettingsFragment].
 */
data class UsernameLinkSettingsState(
  val activeTab: ActiveTab,
  val username: String,
  val usernameLink: String,
  val qrCodeData: QrCodeData?,
  val qrCodeColorScheme: UsernameQrCodeColorScheme,
  val qrScanResult: QrScanResult? = null,
  val indeterminateProgress: Boolean = false
) {
  enum class ActiveTab {
    Code, Scan
  }
}
