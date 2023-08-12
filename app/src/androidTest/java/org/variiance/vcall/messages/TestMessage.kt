package org.variiance.vcall.messages

import org.whispersystems.signalservice.api.crypto.EnvelopeMetadata
import org.whispersystems.signalservice.internal.push.SignalServiceProtos

data class TestMessage(
  val envelope: SignalServiceProtos.Envelope,
  val content: SignalServiceProtos.Content,
  val metadata: EnvelopeMetadata,
  val serverDeliveredTimestamp: Long
)
