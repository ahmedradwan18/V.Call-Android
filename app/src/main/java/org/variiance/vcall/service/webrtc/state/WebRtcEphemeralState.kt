package org.variiance.vcall.service.webrtc.state

import org.variiance.vcall.events.CallParticipant
import org.variiance.vcall.events.CallParticipantId

/**
 * The state of the call system which contains data which changes frequently.
 */
data class WebRtcEphemeralState(
  val localAudioLevel: CallParticipant.AudioLevel = CallParticipant.AudioLevel.LOWEST,
  val remoteAudioLevels: Map<CallParticipantId, CallParticipant.AudioLevel> = emptyMap()
)
