package org.variiance.vcall.components.settings.conversation

import android.content.Context
import android.database.Cursor
import androidx.annotation.WorkerThread
import androidx.lifecycle.LiveData
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.signal.core.util.concurrent.SignalExecutors
import org.signal.core.util.logging.Log
import org.signal.storageservice.protos.groups.local.DecryptedGroup
import org.signal.storageservice.protos.groups.local.DecryptedPendingMember
import org.variiance.vcall.contacts.sync.ContactDiscovery
import org.variiance.vcall.database.CallTable
import org.variiance.vcall.database.MediaTable
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.model.GroupRecord
import org.variiance.vcall.database.model.IdentityRecord
import org.variiance.vcall.database.model.MessageRecord
import org.variiance.vcall.database.model.StoryViewState
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.groups.GroupProtoUtil
import org.variiance.vcall.groups.LiveGroup
import org.variiance.vcall.groups.v2.GroupAddMembersResult
import org.variiance.vcall.groups.v2.GroupManagementRepository
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.recipients.RecipientUtil
import org.variiance.vcall.util.FeatureFlags
import java.io.IOException
import java.util.Optional

private val TAG = Log.tag(ConversationSettingsRepository::class.java)

class ConversationSettingsRepository(
  private val context: Context,
  private val groupManagementRepository: GroupManagementRepository = GroupManagementRepository(context)
) {

  fun getCallEvents(callRowIds: LongArray): Single<List<Pair<CallTable.Call, MessageRecord>>> {
    return if (callRowIds.isEmpty()) {
      Single.just(emptyList())
    } else {
      Single.fromCallable {
        val callMap = SignalDatabase.calls.getCallsByRowIds(callRowIds.toList())
        val messageIds = callMap.values.mapNotNull { it.messageId }
        SignalDatabase.messages.getMessages(messageIds).iterator().asSequence()
          .filter { callMap.containsKey(it.id) }
          .map { callMap[it.id]!! to it }
          .sortedByDescending { it.first.timestamp }
          .toList()
      }
    }
  }

  @WorkerThread
  fun getThreadMedia(threadId: Long): Optional<Cursor> {
    return if (threadId <= 0) {
      Optional.empty()
    } else {
      Optional.of(SignalDatabase.media.getGalleryMediaForThread(threadId, MediaTable.Sorting.Newest))
    }
  }

  fun getStoryViewState(groupId: GroupId): Observable<StoryViewState> {
    return Observable.fromCallable {
      SignalDatabase.recipients.getByGroupId(groupId)
    }.flatMap {
      StoryViewState.getForRecipientId(it.get())
    }.observeOn(Schedulers.io())
  }

  fun getThreadId(recipientId: RecipientId, consumer: (Long) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      consumer(SignalDatabase.threads.getThreadIdIfExistsFor(recipientId))
    }
  }

  fun getThreadId(groupId: GroupId, consumer: (Long) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      val recipientId = Recipient.externalGroupExact(groupId).id
      consumer(SignalDatabase.threads.getThreadIdIfExistsFor(recipientId))
    }
  }

  fun isInternalRecipientDetailsEnabled(): Boolean = SignalStore.internalValues().recipientDetails()

  fun hasGroups(consumer: (Boolean) -> Unit) {
    SignalExecutors.BOUNDED.execute { consumer(SignalDatabase.groups.getActiveGroupCount() > 0) }
  }

  fun getIdentity(recipientId: RecipientId, consumer: (IdentityRecord?) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      if (SignalStore.account().aci != null && SignalStore.account().pni != null) {
        consumer(ApplicationDependencies.getProtocolStore().aci().identities().getIdentityRecord(recipientId).orElse(null))
      } else {
        consumer(null)
      }
    }
  }

  fun getGroupsInCommon(recipientId: RecipientId, consumer: (List<Recipient>) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      consumer(
        SignalDatabase
          .groups
          .getPushGroupsContainingMember(recipientId)
          .asSequence()
          .filter { it.members.contains(Recipient.self().id) }
          .map(GroupRecord::recipientId)
          .map(Recipient::resolved)
          .sortedBy { gr -> gr.getDisplayName(context) }
          .toList()
      )
    }
  }

  fun getGroupMembership(recipientId: RecipientId, consumer: (List<RecipientId>) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      val groupDatabase = SignalDatabase.groups
      val groupRecords = groupDatabase.getPushGroupsContainingMember(recipientId)
      val groupRecipients = ArrayList<RecipientId>(groupRecords.size)
      for (groupRecord in groupRecords) {
        groupRecipients.add(groupRecord.recipientId)
      }
      consumer(groupRecipients)
    }
  }

  fun refreshRecipient(recipientId: RecipientId) {
    SignalExecutors.UNBOUNDED.execute {
      try {
        ContactDiscovery.refresh(context, Recipient.resolved(recipientId), false)
      } catch (e: IOException) {
        Log.w(TAG, "Failed to refresh user after adding to contacts.")
      }
    }
  }

  fun setMuteUntil(recipientId: RecipientId, until: Long) {
    SignalExecutors.BOUNDED.execute {
      SignalDatabase.recipients.setMuted(recipientId, until)
    }
  }

  fun getGroupCapacity(groupId: GroupId, consumer: (GroupCapacityResult) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      val groupRecord: GroupRecord = SignalDatabase.groups.getGroup(groupId).get()
      consumer(
        if (groupRecord.isV2Group) {
          val decryptedGroup: DecryptedGroup = groupRecord.requireV2GroupProperties().decryptedGroup
          val pendingMembers: List<RecipientId> = decryptedGroup.pendingMembersList
            .map(DecryptedPendingMember::getUuid)
            .map(GroupProtoUtil::uuidByteStringToRecipientId)

          val members = mutableListOf<RecipientId>()

          members.addAll(groupRecord.members)
          members.addAll(pendingMembers)

          GroupCapacityResult(Recipient.self().id, members, FeatureFlags.groupLimits(), groupRecord.isAnnouncementGroup)
        } else {
          GroupCapacityResult(Recipient.self().id, groupRecord.members, FeatureFlags.groupLimits(), false)
        }
      )
    }
  }

  fun addMembers(groupId: GroupId, selected: List<RecipientId>, consumer: (GroupAddMembersResult) -> Unit) {
    groupManagementRepository.addMembers(groupId, selected, consumer)
  }

  fun setMuteUntil(groupId: GroupId, until: Long) {
    SignalExecutors.BOUNDED.execute {
      val recipientId = Recipient.externalGroupExact(groupId).id
      SignalDatabase.recipients.setMuted(recipientId, until)
    }
  }

  fun block(recipientId: RecipientId) {
    SignalExecutors.BOUNDED.execute {
      val recipient = Recipient.resolved(recipientId)
      if (recipient.isGroup) {
        RecipientUtil.block(context, recipient)
      } else {
        RecipientUtil.blockNonGroup(context, recipient)
      }
    }
  }

  fun unblock(recipientId: RecipientId) {
    SignalExecutors.BOUNDED.execute {
      val recipient = Recipient.resolved(recipientId)
      RecipientUtil.unblock(recipient)
    }
  }

  fun block(groupId: GroupId) {
    SignalExecutors.BOUNDED.execute {
      val recipient = Recipient.externalGroupExact(groupId)
      RecipientUtil.block(context, recipient)
    }
  }

  fun unblock(groupId: GroupId) {
    SignalExecutors.BOUNDED.execute {
      val recipient = Recipient.externalGroupExact(groupId)
      RecipientUtil.unblock(recipient)
    }
  }

  @WorkerThread
  fun isMessageRequestAccepted(recipient: Recipient): Boolean {
    return RecipientUtil.isMessageRequestAccepted(context, recipient)
  }

  fun getMembershipCountDescription(liveGroup: LiveGroup): LiveData<String> {
    return liveGroup.getMembershipCountDescription(context.resources)
  }

  fun getExternalPossiblyMigratedGroupRecipientId(groupId: GroupId, consumer: (RecipientId) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      consumer(Recipient.externalPossiblyMigratedGroup(groupId).id)
    }
  }
}
