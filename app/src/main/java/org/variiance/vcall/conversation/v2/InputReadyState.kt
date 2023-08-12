/*
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.conversation.v2

import org.variiance.vcall.database.GroupTable
import org.variiance.vcall.database.RecipientTable
import org.variiance.vcall.database.model.GroupRecord
import org.variiance.vcall.messagerequests.MessageRequestState
import org.variiance.vcall.recipients.Recipient

/**
 * Information necessary for rendering compose input.
 */
data class InputReadyState(
  val conversationRecipient: Recipient,
  val messageRequestState: MessageRequestState,
  val groupRecord: GroupRecord?,
  val isClientExpired: Boolean,
  val isUnauthorized: Boolean
) {
  private val selfMemberLevel: GroupTable.MemberLevel? = groupRecord?.memberLevel(Recipient.self())

  val isSignalConversation: Boolean = conversationRecipient.registered == RecipientTable.RegisteredState.REGISTERED && Recipient.self().isRegistered
  val isAnnouncementGroup: Boolean? = groupRecord?.isAnnouncementGroup
  val isActiveGroup: Boolean? = if (selfMemberLevel == null) null else selfMemberLevel != GroupTable.MemberLevel.NOT_A_MEMBER
  val isAdmin: Boolean? = selfMemberLevel?.equals(GroupTable.MemberLevel.ADMINISTRATOR)
  val isRequestingMember: Boolean? = selfMemberLevel?.equals(GroupTable.MemberLevel.REQUESTING_MEMBER)
}
