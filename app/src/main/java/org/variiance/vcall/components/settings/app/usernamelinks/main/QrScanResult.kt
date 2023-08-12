package org.variiance.vcall.components.settings.app.usernamelinks.main

import org.variiance.vcall.recipients.Recipient

/**
 * Result of taking data from the QR scanner and trying to resolve it to a recipient.
 */
sealed class QrScanResult {
  class Success(val recipient: Recipient) : QrScanResult()

  class NotFound(val username: String) : QrScanResult()

  object InvalidData : QrScanResult()

  object NetworkError : QrScanResult()
}
