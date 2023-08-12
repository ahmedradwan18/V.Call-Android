/*
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.components.settings.app.internal.conversation.test

import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.navigation.navGraphViewModels
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.kotlin.subscribeBy
import org.signal.core.util.concurrent.LifecycleDisposable
import org.signal.core.util.logging.Log
import org.signal.ringrtc.CallLinkRootKey
import org.variiance.vcall.R
import org.variiance.vcall.components.ViewBinderDelegate
import org.variiance.vcall.components.recyclerview.SmoothScrollingLinearLayoutManager
import org.variiance.vcall.components.settings.app.internal.conversation.springboard.InternalConversationSpringboardViewModel
import org.variiance.vcall.components.voice.VoiceNotePlaybackState
import org.variiance.vcall.contactshare.Contact
import org.variiance.vcall.conversation.ConversationAdapter.ItemClickListener
import org.variiance.vcall.conversation.ConversationItem
import org.variiance.vcall.conversation.ConversationMessage
import org.variiance.vcall.conversation.colors.ChatColors
import org.variiance.vcall.conversation.colors.ChatColorsPalette
import org.variiance.vcall.conversation.colors.Colorizer
import org.variiance.vcall.conversation.colors.RecyclerViewColorizer
import org.variiance.vcall.conversation.mutiselect.MultiselectPart
import org.variiance.vcall.conversation.v2.ConversationAdapterV2
import org.variiance.vcall.database.model.InMemoryMessageRecord
import org.variiance.vcall.database.model.MessageRecord
import org.variiance.vcall.database.model.MmsMessageRecord
import org.variiance.vcall.databinding.ConversationTestFragmentBinding
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.groups.GroupMigrationMembershipChange
import org.variiance.vcall.linkpreview.LinkPreview
import org.variiance.vcall.mediapreview.MediaIntentFactory
import org.variiance.vcall.mms.GlideApp
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId
import org.variiance.vcall.stickers.StickerLocator
import org.variiance.vcall.util.doAfterNextLayout

class InternalConversationTestFragment : Fragment(R.layout.conversation_test_fragment) {

  companion object {
    private val TAG = Log.tag(InternalConversationTestFragment::class.java)
  }

  private val binding by ViewBinderDelegate(ConversationTestFragmentBinding::bind)
  private val viewModel: InternalConversationTestViewModel by viewModels()
  private val lifecycleDisposable = LifecycleDisposable()
  private val springboardViewModel: InternalConversationSpringboardViewModel by navGraphViewModels(R.id.app_settings)

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    val adapter = ConversationAdapterV2(
      lifecycleOwner = viewLifecycleOwner,
      glideRequests = GlideApp.with(this),
      clickListener = ClickListener(),
      hasWallpaper = springboardViewModel.hasWallpaper.value,
      colorizer = Colorizer(),
      startExpirationTimeout = {}
    )

    if (springboardViewModel.hasWallpaper.value) {
      binding.root.setBackgroundColor(0xFF32C7E2.toInt())
    }

    var startTime = 0L
    var firstRender = true
    lifecycleDisposable.bindTo(viewLifecycleOwner)
    adapter.setPagingController(viewModel.controller)
    lifecycleDisposable += viewModel.data.observeOn(AndroidSchedulers.mainThread()).subscribeBy {
      if (firstRender) {
        startTime = System.currentTimeMillis()
      }
      adapter.submitList(it) {
        if (firstRender) {
          firstRender = false
          binding.root.doAfterNextLayout {
            val endTime = System.currentTimeMillis()
            Log.d(TAG, "First render in ${endTime - startTime} millis")
          }
        }
      }
    }

    binding.recycler.layoutManager = SmoothScrollingLinearLayoutManager(requireContext(), true)
    binding.recycler.adapter = adapter

    RecyclerViewColorizer(binding.recycler).apply {
      setChatColors(ChatColorsPalette.Bubbles.default.withId(ChatColors.Id.Auto))
    }
  }

  private inner class ClickListener : ItemClickListener {
    override fun onQuoteClicked(messageRecord: MmsMessageRecord?) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onLinkPreviewClicked(linkPreview: LinkPreview) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onQuotedIndicatorClicked(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onMoreTextClicked(conversationRecipientId: RecipientId, messageId: Long, isMms: Boolean) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onStickerClicked(stickerLocator: StickerLocator) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onViewOnceMessageClicked(messageRecord: MmsMessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onSharedContactDetailsClicked(contact: Contact, avatarTransitionView: View) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onAddToContactsClicked(contact: Contact) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onMessageSharedContactClicked(choices: MutableList<Recipient>) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onInviteSharedContactClicked(choices: MutableList<Recipient>) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onReactionClicked(multiselectPart: MultiselectPart, messageId: Long, isMms: Boolean) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onGroupMemberClicked(recipientId: RecipientId, groupId: GroupId) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onMessageWithErrorClicked(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onMessageWithRecaptchaNeededClicked(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onIncomingIdentityMismatchClicked(recipientId: RecipientId) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onRegisterVoiceNoteCallbacks(onPlaybackStartObserver: Observer<VoiceNotePlaybackState>) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onUnregisterVoiceNoteCallbacks(onPlaybackStartObserver: Observer<VoiceNotePlaybackState>) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onVoiceNotePause(uri: Uri) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onVoiceNotePlay(uri: Uri, messageId: Long, position: Double) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onVoiceNoteSeekTo(uri: Uri, position: Double) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onVoiceNotePlaybackSpeedChanged(uri: Uri, speed: Float) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onGroupMigrationLearnMoreClicked(membershipChange: GroupMigrationMembershipChange) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onChatSessionRefreshLearnMoreClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onBadDecryptLearnMoreClicked(author: RecipientId) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onSafetyNumberLearnMoreClicked(recipient: Recipient) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onJoinGroupCallClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onInviteFriendsToGroupClicked(groupId: GroupId.V2) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onEnableCallNotificationsClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onPlayInlineContent(conversationMessage: ConversationMessage?) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onInMemoryMessageClicked(messageRecord: InMemoryMessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onViewGroupDescriptionChange(groupId: GroupId?, description: String, isMessageRequestAccepted: Boolean) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onChangeNumberUpdateContact(recipient: Recipient) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onCallToAction(action: String) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onDonateClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onBlockJoinRequest(recipient: Recipient) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onRecipientNameClicked(target: RecipientId) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onInviteToSignalClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onActivatePaymentsClicked() {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onSendPaymentClicked(recipientId: RecipientId) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onScheduledIndicatorClicked(view: View, conversationMessage: ConversationMessage) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onUrlClicked(url: String): Boolean {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
      return true
    }

    override fun onViewGiftBadgeClicked(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onGiftBadgeRevealed(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun goToMediaPreview(parent: ConversationItem?, sharedElement: View?, args: MediaIntentFactory.MediaPreviewArgs?) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onEditedIndicatorClicked(messageRecord: MessageRecord) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onShowGroupDescriptionClicked(groupName: String, description: String, shouldLinkifyWebLinks: Boolean) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onJoinCallLink(callLinkRootKey: CallLinkRootKey) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onItemClick(item: MultiselectPart?) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }

    override fun onItemLongClick(itemView: View?, item: MultiselectPart?) {
      Toast.makeText(requireContext(), "Can't touch this.", Toast.LENGTH_SHORT).show()
    }
  }
}
