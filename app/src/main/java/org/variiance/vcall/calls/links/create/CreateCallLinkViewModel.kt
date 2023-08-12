/**
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.calls.links.create

import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.disposables.CompositeDisposable
import io.reactivex.rxjava3.kotlin.plusAssign
import io.reactivex.rxjava3.kotlin.subscribeBy
import org.signal.ringrtc.CallLinkState.Restrictions
import org.variiance.vcall.calls.links.CallLinks
import org.variiance.vcall.calls.links.UpdateCallLinkRepository
import org.variiance.vcall.database.CallLinkTable
import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.service.webrtc.links.CallLinkCredentials
import org.variiance.vcall.service.webrtc.links.SignalCallLinkState
import org.variiance.vcall.service.webrtc.links.UpdateCallLinkResult
import java.time.Instant

class CreateCallLinkViewModel(
  private val repository: CreateCallLinkRepository = CreateCallLinkRepository(),
  private val mutationRepository: UpdateCallLinkRepository = UpdateCallLinkRepository()
) : ViewModel() {
  private val credentials = CallLinkCredentials.generate()
  private val _callLink: MutableState<CallLinkTable.CallLink> = mutableStateOf(
    CallLinkTable.CallLink(
      recipientId = RecipientId.UNKNOWN,
      roomId = credentials.roomId,
      credentials = credentials,
      state = SignalCallLinkState(
        name = "",
        restrictions = Restrictions.NONE,
        revoked = false,
        expiration = Instant.MAX
      )
    )
  )

  val callLink: State<CallLinkTable.CallLink> = _callLink
  val linkKeyBytes: ByteArray = credentials.linkKeyBytes

  private val disposables = CompositeDisposable()

  init {
    disposables += CallLinks.watchCallLink(credentials.roomId)
      .subscribeBy {
        _callLink.value = it
      }
  }

  override fun onCleared() {
    super.onCleared()
    disposables.dispose()
  }

  fun commitCallLink(): Single<EnsureCallLinkCreatedResult> {
    return repository.ensureCallLinkCreated(credentials)
  }

  fun setApproveAllMembers(approveAllMembers: Boolean): Single<UpdateCallLinkResult> {
    return commitCallLink()
      .flatMap {
        when (it) {
          is EnsureCallLinkCreatedResult.Success -> mutationRepository.setCallRestrictions(
            credentials,
            if (approveAllMembers) Restrictions.ADMIN_APPROVAL else Restrictions.NONE
          )
          is EnsureCallLinkCreatedResult.Failure -> Single.just(UpdateCallLinkResult.Failure(it.failure.status))
        }
      }
  }

  fun toggleApproveAllMembers(): Single<UpdateCallLinkResult> {
    return setApproveAllMembers(_callLink.value.state.restrictions != Restrictions.ADMIN_APPROVAL)
  }

  fun setCallName(callName: String): Single<UpdateCallLinkResult> {
    return commitCallLink()
      .flatMap {
        when (it) {
          is EnsureCallLinkCreatedResult.Success -> mutationRepository.setCallName(
            credentials,
            callName
          )
          is EnsureCallLinkCreatedResult.Failure -> Single.just(UpdateCallLinkResult.Failure(it.failure.status))
        }
      }
  }
}
