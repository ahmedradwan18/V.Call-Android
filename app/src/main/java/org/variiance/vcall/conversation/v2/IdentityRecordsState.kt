/*
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.conversation.v2

import org.variiance.vcall.database.identity.IdentityRecordList
import org.variiance.vcall.database.model.GroupRecord
import org.variiance.vcall.database.model.IdentityRecord
import org.variiance.vcall.recipients.Recipient

/**
 * Current state for all participants identity keys in a conversation excluding self.
 */
data class IdentityRecordsState(
  val recipient: Recipient? = null,
  val group: GroupRecord? = null,
  val isVerified: Boolean = false,
  val identityRecords: IdentityRecordList = IdentityRecordList(emptyList()),
  val isGroup: Boolean = false
) {
  val isUnverified: Boolean = identityRecords.isUnverified

  fun hasRecentSafetyNumberChange(): Boolean {
    return identityRecords.isUnverified(true) || identityRecords.isUntrusted(true)
  }

  fun getRecentSafetyNumberChangeRecords(): List<IdentityRecord> {
    return identityRecords.unverifiedRecords + identityRecords.untrustedRecords
  }
}
