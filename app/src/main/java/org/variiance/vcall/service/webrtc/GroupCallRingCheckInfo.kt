package org.variiance.vcall.service.webrtc

import org.signal.ringrtc.CallManager
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.recipients.RecipientId
import java.util.UUID

data class GroupCallRingCheckInfo(
  val recipientId: RecipientId,
  val groupId: GroupId.V2,
  val ringId: Long,
  val ringerUuid: UUID,
  val ringUpdate: CallManager.RingUpdate
)
