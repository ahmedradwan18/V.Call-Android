package org.variiance.vcall.components.settings.app.notifications.profiles

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.core.Single
import org.variiance.vcall.notifications.profiles.NotificationProfile
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId

class AddAllowedMembersViewModel(private val profileId: Long, private val repository: NotificationProfilesRepository) : ViewModel() {

  fun getProfile(): Observable<NotificationProfileAndRecipients> {
    return repository.getProfile(profileId)
      .map { profile ->
        NotificationProfileAndRecipients(profile, profile.allowedMembers.map { Recipient.resolved(it) })
      }
      .observeOn(AndroidSchedulers.mainThread())
  }

  fun addMember(id: RecipientId): Single<NotificationProfile> {
    return repository.addMember(profileId, id)
      .observeOn(AndroidSchedulers.mainThread())
  }

  fun removeMember(id: RecipientId): Single<Recipient> {
    return repository.removeMember(profileId, id)
      .map { Recipient.resolved(id) }
      .observeOn(AndroidSchedulers.mainThread())
  }

  data class NotificationProfileAndRecipients(val profile: NotificationProfile, val recipients: List<Recipient>)

  class Factory(private val profileId: Long) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
      return modelClass.cast(AddAllowedMembersViewModel(profileId, NotificationProfilesRepository()))!!
    }
  }
}
