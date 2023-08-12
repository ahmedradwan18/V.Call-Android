package org.variiance.vcall.stories.settings.group

import io.reactivex.rxjava3.core.Completable
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.variiance.vcall.database.GroupTable
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.storage.StorageSyncHelper

class GroupStorySettingsRepository {
  fun unmarkAsGroupStory(groupId: GroupId): Completable {
    return Completable.fromAction {
      SignalDatabase.groups.setShowAsStoryState(groupId, GroupTable.ShowAsStoryState.NEVER)
      SignalDatabase.recipients.markNeedsSync(Recipient.externalGroupExact(groupId).id)
      StorageSyncHelper.scheduleSyncForDataChange()
    }.subscribeOn(Schedulers.io())
  }

  fun getConversationData(groupId: GroupId): Single<GroupConversationData> {
    return Single.fromCallable {
      val recipientId = SignalDatabase.recipients.getByGroupId(groupId).get()
      val threadId = SignalDatabase.threads.getThreadIdFor(recipientId) ?: -1L

      GroupConversationData(recipientId, threadId)
    }.subscribeOn(Schedulers.io())
  }
}
