/*
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.database

import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.storage.StorageRecordUpdate
import org.variiance.vcall.storage.StorageSyncModels
import org.variiance.vcall.testing.SignalActivityRule
import org.variiance.vcall.testing.assertIs
import org.variiance.vcall.util.MessageTableTestUtils
import org.whispersystems.signalservice.api.storage.SignalContactRecord
import org.whispersystems.signalservice.internal.storage.protos.ContactRecord

@Suppress("ClassName")
@RunWith(AndroidJUnit4::class)
class RecipientTableTest_applyStorageSyncContactUpdate {
  @get:Rule
  val harness = SignalActivityRule()

  @Test
  fun insertMessageOnVerifiedToDefault() {
    // GIVEN
    val identities = ApplicationDependencies.getProtocolStore().aci().identities()
    val other = Recipient.resolved(harness.others[0])

    MmsHelper.insert(recipient = other)
    identities.setVerified(other.id, harness.othersKeys[0].publicKey, IdentityTable.VerifiedStatus.VERIFIED)

    val oldRecord: SignalContactRecord = StorageSyncModels.localToRemoteRecord(SignalDatabase.recipients.getRecordForSync(harness.others[0])!!).contact.get()

    val newProto = oldRecord
      .toProto()
      .toBuilder()
      .setIdentityState(ContactRecord.IdentityState.DEFAULT)
      .build()
    val newRecord = SignalContactRecord(oldRecord.id, newProto)

    val update = StorageRecordUpdate<SignalContactRecord>(oldRecord, newRecord)

    // WHEN
    val oldVerifiedStatus: IdentityTable.VerifiedStatus = identities.getIdentityRecord(other.id).get().verifiedStatus
    SignalDatabase.recipients.applyStorageSyncContactUpdate(update)
    val newVerifiedStatus: IdentityTable.VerifiedStatus = identities.getIdentityRecord(other.id).get().verifiedStatus

    // THEN
    oldVerifiedStatus assertIs IdentityTable.VerifiedStatus.VERIFIED
    newVerifiedStatus assertIs IdentityTable.VerifiedStatus.DEFAULT

    val messages = MessageTableTestUtils.getMessages(SignalDatabase.threads.getThreadIdFor(other.id)!!)
    messages.first().isIdentityDefault assertIs true
  }
}
