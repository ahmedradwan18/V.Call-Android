/*
 * Copyright (C) 2014-2017 Open Whisper Systems
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.variiance.vcall.conversationlist;

import android.content.Context;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.style.CharacterStyle;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.util.AttributeSet;
import android.view.TouchDelegate;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.ColorInt;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Px;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.Observer;
import androidx.lifecycle.Transformations;

import com.bumptech.glide.load.resource.bitmap.CenterCrop;
import com.makeramen.roundedimageview.RoundedDrawable;

import org.signal.core.util.DimensionUnit;
import org.signal.core.util.StringUtil;
import org.signal.core.util.logging.Log;
import org.variiance.vcall.BindableConversationListItem;
import org.variiance.vcall.OverlayTransformation;
import org.variiance.vcall.R;
import org.variiance.vcall.Unbindable;
import org.variiance.vcall.badges.BadgeImageView;
import org.variiance.vcall.components.AlertView;
import org.variiance.vcall.components.AvatarImageView;
import org.variiance.vcall.components.DeliveryStatusView;
import org.variiance.vcall.components.FromTextView;
import org.variiance.vcall.components.TypingIndicatorView;
import org.variiance.vcall.components.emoji.EmojiStrings;
import org.variiance.vcall.components.emoji.EmojiTextView;
import org.variiance.vcall.components.emoji.SimpleEmojiTextView;
import org.variiance.vcall.contacts.paged.ContactSearchData;
import org.variiance.vcall.conversation.MessageStyler;
import org.variiance.vcall.conversationlist.model.ConversationSet;
import org.variiance.vcall.database.MessageTypes;
import org.variiance.vcall.database.ThreadTable;
import org.variiance.vcall.database.model.LiveUpdateMessage;
import org.variiance.vcall.database.model.MessageRecord;
import org.variiance.vcall.database.model.ThreadRecord;
import org.variiance.vcall.database.model.UpdateDescription;
import org.variiance.vcall.glide.GlideLiveDataTarget;
import org.variiance.vcall.mms.DecryptableStreamUriLoader;
import org.variiance.vcall.mms.GlideRequests;
import org.variiance.vcall.phonenumbers.PhoneNumberFormatter;
import org.variiance.vcall.recipients.LiveRecipient;
import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.recipients.RecipientId;
import org.variiance.vcall.search.MessageResult;
import org.variiance.vcall.util.DateUtils;
import org.variiance.vcall.util.ExpirationUtil;
import org.variiance.vcall.util.MediaUtil;
import org.variiance.vcall.util.SearchUtil;
import org.variiance.vcall.util.SpanUtil;
import org.variiance.vcall.util.Util;
import org.variiance.vcall.util.livedata.LiveDataUtil;

import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers;
import io.reactivex.rxjava3.core.Single;
import io.reactivex.rxjava3.disposables.Disposable;
import io.reactivex.rxjava3.schedulers.Schedulers;

import static org.variiance.vcall.database.model.LiveUpdateMessage.recipientToStringAsync;

public final class ConversationListItem extends ConstraintLayout implements BindableConversationListItem, Unbindable {
  @SuppressWarnings("unused")
  private final static String TAG = Log.tag(ConversationListItem.class);

  private final static Typeface BOLD_TYPEFACE  = Typeface.create("sans-serif-medium", Typeface.NORMAL);
  private final static Typeface LIGHT_TYPEFACE = Typeface.create("sans-serif", Typeface.NORMAL);

  private final Rect                      conversationAvatarTouchDelegateBounds    = new Rect();
  private final Rect                      newConversationAvatarTouchDelegateBounds = new Rect();
  private final Observer<Recipient>       recipientObserver                        = this::onRecipientChanged;
  private final Observer<SpannableString> displayBodyObserver                      = this::onDisplayBodyChanged;

  private Set<Long>           typingThreads;
  private LiveRecipient       recipient;
  private long                threadId;
  private GlideRequests       glideRequests;
  private EmojiTextView       subjectView;
  private TypingIndicatorView typingView;
  private FromTextView        fromView;
  private TextView            dateView;
  private TextView            archivedView;
  private DeliveryStatusView  deliveryStatusIndicator;
  private AlertView           alertView;
  private TextView            unreadIndicator;
  private long                lastSeen;
  private ThreadRecord        thread;
  private boolean             batchMode;
  private Locale              locale;
  private String              highlightSubstring;
  private BadgeImageView      badge;
  private View                checkContainer;
  private View                uncheckedView;
  private View                checkedView;
  private View                unreadMentions;
  private int                 thumbSize;
  private GlideLiveDataTarget thumbTarget;

  private int                     unreadCount;
  private AvatarImageView         contactPhotoImage;
  private SearchUtil.StyleFactory searchStyleFactory;

  private LiveData<SpannableString> displayBody;
  private Disposable                joinMembersDisposable = Disposable.empty();

  public ConversationListItem(Context context) {
    this(context, null);
  }

  public ConversationListItem(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  @Override
  protected void onFinishInflate() {
    super.onFinishInflate();
    this.subjectView             = findViewById(R.id.conversation_list_item_summary);
    this.typingView              = findViewById(R.id.conversation_list_item_typing_indicator);
    this.fromView                = findViewById(R.id.conversation_list_item_name);
    this.dateView                = findViewById(R.id.conversation_list_item_date);
    this.deliveryStatusIndicator = findViewById(R.id.conversation_list_item_status);
    this.alertView               = findViewById(R.id.conversation_list_item_alert);
    this.contactPhotoImage       = findViewById(R.id.conversation_list_item_avatar);
    this.archivedView            = findViewById(R.id.conversation_list_item_archived);
    this.unreadIndicator         = findViewById(R.id.conversation_list_item_unread_indicator);
    this.badge                   = findViewById(R.id.conversation_list_item_badge);
    this.checkContainer          = findViewById(R.id.conversation_list_item_check_container);
    this.uncheckedView           = findViewById(R.id.conversation_list_item_unchecked);
    this.checkedView             = findViewById(R.id.conversation_list_item_checked);
    this.unreadMentions          = findViewById(R.id.conversation_list_item_unread_mentions_indicator);
    this.thumbSize               = (int) DimensionUnit.SP.toPixels(16f);
    this.thumbTarget             = new GlideLiveDataTarget(thumbSize, thumbSize);
    this.searchStyleFactory      = () -> new CharacterStyle[] { new ForegroundColorSpan(ContextCompat.getColor(getContext(), R.color.signal_colorOnSurface)), SpanUtil.getBoldSpan() };

    getLayoutTransition().setDuration(150);

    this.subjectView.setOverflowText(" ");
  }

  /**
   *
   */
  @SuppressWarnings("DrawAllocation")
  @Override
  protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
    super.onLayout(changed, left, top, right, bottom);

    contactPhotoImage.getHitRect(newConversationAvatarTouchDelegateBounds);

    if (getLayoutDirection() == LAYOUT_DIRECTION_LTR) {
      newConversationAvatarTouchDelegateBounds.left = left;
    } else {
      newConversationAvatarTouchDelegateBounds.right = right;
    }

    newConversationAvatarTouchDelegateBounds.top    = top;
    newConversationAvatarTouchDelegateBounds.bottom = bottom;

    TouchDelegate currentDelegate = getTouchDelegate();

    if (currentDelegate == null || !newConversationAvatarTouchDelegateBounds.equals(conversationAvatarTouchDelegateBounds)) {
      conversationAvatarTouchDelegateBounds.set(newConversationAvatarTouchDelegateBounds);
      TouchDelegate conversationAvatarTouchDelegate = new TouchDelegate(conversationAvatarTouchDelegateBounds, contactPhotoImage);
      setTouchDelegate(conversationAvatarTouchDelegate);
    }
  }

  @Override
  public void bind(@NonNull LifecycleOwner lifecycleOwner,
                   @NonNull ThreadRecord thread,
                   @NonNull GlideRequests glideRequests,
                   @NonNull Locale locale,
                   @NonNull Set<Long> typingThreads,
                   @NonNull ConversationSet selectedConversations)
  {
    bindThread(lifecycleOwner, thread, glideRequests, locale, typingThreads, selectedConversations, null);
  }

  public void bindThread(@NonNull LifecycleOwner lifecycleOwner,
                         @NonNull ThreadRecord thread,
                         @NonNull GlideRequests glideRequests,
                         @NonNull Locale locale,
                         @NonNull Set<Long> typingThreads,
                         @NonNull ConversationSet selectedConversations,
                         @Nullable String highlightSubstring)
  {
    this.threadId           = thread.getThreadId();
    this.glideRequests      = glideRequests;
    this.unreadCount        = thread.getUnreadCount();
    this.lastSeen           = thread.getLastSeen();
    this.thread             = thread;
    this.locale             = locale;
    this.highlightSubstring = highlightSubstring;

    observeRecipient(lifecycleOwner, thread.getRecipient().live());
    observeDisplayBody(null, null);
    joinMembersDisposable.dispose();

    if (highlightSubstring != null) {
      String name = recipient.get().isSelf() ? getContext().getString(R.string.note_to_self) : recipient.get().getDisplayName(getContext());

      this.fromView.setText(recipient.get(), SearchUtil.getHighlightedSpan(locale, searchStyleFactory, name, highlightSubstring, SearchUtil.MATCH_ALL), true, null);
    } else {
      this.fromView.setText(recipient.get(), false);
    }

    this.typingThreads = typingThreads;
    updateTypingIndicator(typingThreads);

    LiveData<SpannableString> displayBody = getThreadDisplayBody(getContext(), thread, glideRequests, thumbSize, thumbTarget);
    setSubjectViewText(displayBody.getValue());
    observeDisplayBody(lifecycleOwner, displayBody);

    if (thread.getDate() > 0) {
      CharSequence date = DateUtils.getBriefRelativeTimeSpanString(getContext(), locale, thread.getDate());
      dateView.setText(date);
      dateView.setTypeface(thread.isRead() ? LIGHT_TYPEFACE : BOLD_TYPEFACE);
      dateView.setTextColor(thread.isRead() ? ContextCompat.getColor(getContext(), R.color.signal_text_secondary)
                                            : ContextCompat.getColor(getContext(), R.color.signal_text_primary));
    }

    if (thread.isArchived()) {
      this.archivedView.setVisibility(View.VISIBLE);
    } else {
      this.archivedView.setVisibility(View.GONE);
    }

    setStatusIcons(thread);
    setSelectedConversations(selectedConversations);
    setBadgeFromRecipient(recipient.get());
    setUnreadIndicator(thread);
    this.contactPhotoImage.setAvatar(glideRequests, recipient.get(), !batchMode);
  }

  private void setBadgeFromRecipient(Recipient recipient) {
    if (!recipient.isSelf()) {
      badge.setBadgeFromRecipient(recipient);
      badge.setClickable(false);
    } else {
      badge.setBadge(null);
    }
  }

  public void bindContact(@NonNull LifecycleOwner lifecycleOwner,
                          @NonNull Recipient contact,
                          @NonNull GlideRequests glideRequests,
                          @NonNull Locale locale,
                          @Nullable String highlightSubstring)
  {
    this.glideRequests      = glideRequests;
    this.locale             = locale;
    this.highlightSubstring = highlightSubstring;

    observeRecipient(lifecycleOwner, contact.live());
    observeDisplayBody(null, null);
    joinMembersDisposable.dispose();
    setSubjectViewText(null);

    fromView.setText(contact, SearchUtil.getHighlightedSpan(locale, searchStyleFactory, new SpannableString(contact.getDisplayName(getContext())), highlightSubstring, SearchUtil.MATCH_ALL), true, null);
    setSubjectViewText(SearchUtil.getHighlightedSpan(locale, searchStyleFactory, contact.getE164().orElse(""), highlightSubstring, SearchUtil.MATCH_ALL));
    dateView.setText("");
    archivedView.setVisibility(GONE);
    unreadIndicator.setVisibility(GONE);
    unreadMentions.setVisibility(GONE);
    deliveryStatusIndicator.setNone();
    alertView.setNone();

    setSelectedConversations(new ConversationSet());
    setBadgeFromRecipient(recipient.get());
    contactPhotoImage.setAvatar(glideRequests, recipient.get(), !batchMode);
  }

  public void bindMessage(@NonNull LifecycleOwner lifecycleOwner,
                          @NonNull MessageResult messageResult,
                          @NonNull GlideRequests glideRequests,
                          @NonNull Locale locale,
                          @Nullable String highlightSubstring)
  {
    this.glideRequests      = glideRequests;
    this.locale             = locale;
    this.highlightSubstring = highlightSubstring;

    observeRecipient(lifecycleOwner, messageResult.getConversationRecipient().live());
    observeDisplayBody(null, null);
    joinMembersDisposable.dispose();
    setSubjectViewText(null);

    fromView.setText(recipient.get(), false);
    setSubjectViewText(SearchUtil.getHighlightedSpan(locale, searchStyleFactory, messageResult.getBodySnippet(), highlightSubstring, SearchUtil.MATCH_ALL));
    dateView.setText(DateUtils.getBriefRelativeTimeSpanString(getContext(), locale, messageResult.getReceivedTimestampMs()));
    archivedView.setVisibility(GONE);
    unreadIndicator.setVisibility(GONE);
    unreadMentions.setVisibility(GONE);
    deliveryStatusIndicator.setNone();
    alertView.setNone();

    setSelectedConversations(new ConversationSet());
    setBadgeFromRecipient(recipient.get());
    contactPhotoImage.setAvatar(glideRequests, recipient.get(), !batchMode);
  }

  public void bindGroupWithMembers(@NonNull LifecycleOwner lifecycleOwner,
                                   @NonNull ContactSearchData.GroupWithMembers groupWithMembers,
                                   @NonNull GlideRequests glideRequests,
                                   @NonNull Locale locale)
  {
    this.glideRequests      = glideRequests;
    this.locale             = locale;
    this.highlightSubstring = groupWithMembers.getQuery();

    observeRecipient(lifecycleOwner, Recipient.live(groupWithMembers.getGroupRecord().getRecipientId()));
    observeDisplayBody(null, null);
    joinMembersDisposable.dispose();
    joinMembersDisposable = joinMembersToDisplayBody(groupWithMembers.getGroupRecord().getMembers(), groupWithMembers.getQuery()).subscribe(joined -> {
      setSubjectViewText(SearchUtil.getHighlightedSpan(locale, searchStyleFactory, joined, highlightSubstring, SearchUtil.MATCH_ALL));
    });

    fromView.setText(recipient.get(), false);
    dateView.setText(DateUtils.getBriefRelativeTimeSpanString(getContext(), locale, groupWithMembers.getDate()));
    archivedView.setVisibility(GONE);
    unreadIndicator.setVisibility(GONE);
    unreadMentions.setVisibility(GONE);
    deliveryStatusIndicator.setNone();
    alertView.setNone();

    setSelectedConversations(new ConversationSet());
    setBadgeFromRecipient(recipient.get());
    contactPhotoImage.setAvatar(glideRequests, recipient.get(), !batchMode);
  }

  private @NonNull Single<String> joinMembersToDisplayBody(@NonNull List<RecipientId> members, @NonNull String highlightSubstring) {
    return Single.fromCallable(() -> {
      return Util.join(Recipient.resolvedList(members)
                                .stream()
                                .map(r -> r.getDisplayName(getContext()))
                                .sorted(new JoinMembersComparator(highlightSubstring))
                                .limit(5)
                                .collect(Collectors.toList()), ",");
    }).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread());
  }

  @Override
  public void unbind() {
    if (this.recipient != null) {
      observeRecipient(null, null);
      setSelectedConversations(new ConversationSet());
      contactPhotoImage.setAvatar(glideRequests, null, !batchMode);
    }

    observeDisplayBody(null, null);
    joinMembersDisposable.dispose();
  }

  @Override
  public void setSelectedConversations(@NonNull ConversationSet conversations) {
    this.batchMode = !conversations.isEmpty();

    boolean selected = batchMode && conversations.containsThreadId(thread.getThreadId());
    setSelected(selected);

    if (recipient != null) {
      contactPhotoImage.setAvatar(glideRequests, recipient.get(), !batchMode);
    }

    if (batchMode && selected) {
      checkContainer.setVisibility(VISIBLE);
      uncheckedView.setVisibility(GONE);
      checkedView.setVisibility(VISIBLE);
    } else if (batchMode) {
      checkContainer.setVisibility(VISIBLE);
      uncheckedView.setVisibility(VISIBLE);
      checkedView.setVisibility(GONE);
    } else {
      checkContainer.setVisibility(GONE);
      uncheckedView.setVisibility(GONE);
      checkedView.setVisibility(GONE);
    }
  }

  @Override
  public void updateTypingIndicator(@NonNull Set<Long> typingThreads) {
    if (typingThreads.contains(threadId)) {
      this.subjectView.setVisibility(INVISIBLE);

      this.typingView.setVisibility(VISIBLE);
      this.typingView.startAnimation();
    } else {
      this.typingView.setVisibility(GONE);
      this.typingView.stopAnimation();

      this.subjectView.setVisibility(VISIBLE);
    }
  }

  public Recipient getRecipient() {
    return recipient.get();
  }

  public long getThreadId() {
    return threadId;
  }

  public @NonNull ThreadRecord getThread() {
    return thread;
  }

  public int getUnreadCount() {
    return unreadCount;
  }

  public long getLastSeen() {
    return lastSeen;
  }

  private void observeRecipient(@Nullable LifecycleOwner lifecycleOwner, @Nullable LiveRecipient newRecipient) {
    if (this.recipient != null) {
      this.recipient.getLiveData().removeObserver(recipientObserver);
    }

    this.recipient = newRecipient;

    if (lifecycleOwner != null && this.recipient != null) {
      this.recipient.getLiveData().observe(lifecycleOwner, recipientObserver);
    }
  }

  private void observeDisplayBody(@Nullable LifecycleOwner lifecycleOwner, @Nullable LiveData<SpannableString> displayBody) {
    if (displayBody == null && glideRequests != null) {
      glideRequests.clear(thumbTarget);
    }

    if (this.displayBody != null) {
      this.displayBody.removeObserver(displayBodyObserver);
    }

    this.displayBody = displayBody;

    if (lifecycleOwner != null && this.displayBody != null) {
      this.displayBody.observe(lifecycleOwner, displayBodyObserver);
    }
  }

  private void setSubjectViewText(@Nullable CharSequence text) {
    if (text == null) {
      subjectView.setText(null);
    } else {
      subjectView.setText(text);
      subjectView.setVisibility(VISIBLE);
    }
  }

  private void setStatusIcons(ThreadRecord thread) {
    if (MessageTypes.isBadDecryptType(thread.getType())) {
      deliveryStatusIndicator.setNone();
      alertView.setFailed();
    } else if (!thread.isOutgoing() ||
               thread.isOutgoingAudioCall() ||
               thread.isOutgoingVideoCall() ||
               thread.isVerificationStatusChange() ||
               thread.isScheduledMessage())
    {
      deliveryStatusIndicator.setNone();
      alertView.setNone();
    } else if (thread.isFailed()) {
      deliveryStatusIndicator.setNone();
      alertView.setFailed();
    } else if (thread.isPendingInsecureSmsFallback()) {
      deliveryStatusIndicator.setNone();
      alertView.setPendingApproval();
    } else {
      alertView.setNone();

      if (thread.getExtra() != null && thread.getExtra().isRemoteDelete()) {
        if (thread.isPending()) {
          deliveryStatusIndicator.setPending();
        } else {
          deliveryStatusIndicator.setNone();
        }
      } else {
        if (thread.isPending()) {
          deliveryStatusIndicator.setPending();
        } else if (thread.isRemoteRead()) {
          deliveryStatusIndicator.setRead();
        } else if (thread.isDelivered()) {
          deliveryStatusIndicator.setDelivered();
        } else {
          deliveryStatusIndicator.setSent();
        }
      }
    }
  }

  private void setUnreadIndicator(ThreadRecord thread) {
    if (thread.isRead()) {
      unreadIndicator.setVisibility(View.GONE);
      unreadMentions.setVisibility(View.GONE);
      return;
    }

    if (thread.getUnreadSelfMentionsCount() > 0) {
      unreadMentions.setVisibility(View.VISIBLE);
      unreadIndicator.setVisibility(thread.getUnreadCount() == 1 ? View.GONE : View.VISIBLE);
    } else {
      unreadMentions.setVisibility(View.GONE);
      unreadIndicator.setVisibility(View.VISIBLE);
    }

    unreadIndicator.setText(unreadCount > 0 ? String.valueOf(unreadCount) : " ");
  }

  private void onRecipientChanged(@NonNull Recipient recipient) {
    if (this.recipient == null || !this.recipient.getId().equals(recipient.getId())) {
      Log.w(TAG, "Bad change! Local recipient doesn't match. Ignoring. Local: " + (this.recipient == null ? "null" : this.recipient.getId()) + ", Changed: " + recipient.getId());
      return;
    }

    if (highlightSubstring != null) {
      String name = recipient.isSelf() ? getContext().getString(R.string.note_to_self) : recipient.getDisplayName(getContext());
      fromView.setText(recipient, SearchUtil.getHighlightedSpan(locale, searchStyleFactory, new SpannableString(name), highlightSubstring, SearchUtil.MATCH_ALL), true, null);
    } else {
      fromView.setText(recipient, false);
    }
    contactPhotoImage.setAvatar(glideRequests, recipient, !batchMode);
    setBadgeFromRecipient(recipient);
  }

  private static @NonNull LiveData<SpannableString> getThreadDisplayBody(@NonNull Context context,
                                                                         @NonNull ThreadRecord thread,
                                                                         @NonNull GlideRequests glideRequests,
                                                                         @Px int thumbSize,
                                                                         @NonNull GlideLiveDataTarget thumbTarget)
  {
    int defaultTint = ContextCompat.getColor(context, R.color.signal_text_secondary);

    if (!thread.isMessageRequestAccepted()) {
      if (thread.isRecipientHidden()) {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_hidden_recipient), defaultTint);
      } else {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_message_request), defaultTint);
      }
    } else if (MessageTypes.isGroupUpdate(thread.getType())) {
      if (thread.getRecipient().isPushV2Group()) {
        return emphasisAdded(context, MessageRecord.getGv2ChangeDescription(context, thread.getBody(), null), defaultTint);
      } else {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_group_updated), R.drawable.ic_update_group_16, defaultTint);
      }
    } else if (MessageTypes.isGroupQuit(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_left_the_group), R.drawable.ic_update_group_leave_16, defaultTint);
    } else if (MessageTypes.isKeyExchangeType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ConversationListItem_key_exchange_message), defaultTint);
    } else if (MessageTypes.isChatSessionRefresh(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_chat_session_refreshed), R.drawable.ic_refresh_16, defaultTint);
    } else if (MessageTypes.isNoRemoteSessionType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.MessageDisplayHelper_message_encrypted_for_non_existing_session), defaultTint);
    } else if (MessageTypes.isEndSessionType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_secure_session_reset), defaultTint);
    } else if (MessageTypes.isLegacyType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.MessageRecord_message_encrypted_with_a_legacy_protocol_version_that_is_no_longer_supported), defaultTint);
    } else if (thread.isScheduledMessage()) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_scheduled_message), R.drawable.symbol_calendar_compact_light_16, defaultTint);
    } else if (MessageTypes.isDraftMessageType(thread.getType())) {
      String draftText = context.getString(R.string.ThreadRecord_draft);
      return emphasisAdded(context, draftText + " " + thread.getBody(), defaultTint);
    } else if (MessageTypes.isOutgoingAudioCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_outgoing_voice_call) : thread.getBody(), R.drawable.ic_update_audio_call_outgoing_16, defaultTint);
    } else if (MessageTypes.isOutgoingVideoCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_outgoing_video_call) : thread.getBody(), R.drawable.ic_update_video_call_outgoing_16, defaultTint);
    } else if (MessageTypes.isIncomingAudioCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_incoming_voice_call) : thread.getBody(), R.drawable.ic_update_audio_call_incoming_16, defaultTint);
    } else if (MessageTypes.isIncomingVideoCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_incoming_video_call) : thread.getBody(), R.drawable.ic_update_video_call_incoming_16, defaultTint);
    } else if (MessageTypes.isMissedAudioCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_missed_voice_call) : thread.getBody(), R.drawable.ic_update_audio_call_missed_16, defaultTint);
    } else if (MessageTypes.isMissedVideoCall(thread.getType())) {
      return emphasisAdded(context, StringUtil.isEmpty(thread.getBody()) ? context.getString(R.string.MessageRecord_missed_video_call) : thread.getBody(), R.drawable.ic_update_video_call_missed_16, defaultTint);
    } else if (MessageTypes.isGroupCall(thread.getType())) {
      return emphasisAdded(context, MessageRecord.getGroupCallUpdateDescription(context, thread.getBody(), false), defaultTint);
    } else if (MessageTypes.isJoinedType(thread.getType())) {
      return emphasisAdded(recipientToStringAsync(thread.getRecipient().getId(), r -> new SpannableString(context.getString(R.string.ThreadRecord_s_is_on_signal, r.getDisplayName(context)))));
    } else if (MessageTypes.isExpirationTimerUpdate(thread.getType())) {
      int seconds = (int) (thread.getExpiresIn() / 1000);
      if (seconds <= 0) {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_disappearing_messages_disabled), R.drawable.ic_update_timer_disabled_16, defaultTint);
      }
      String time = ExpirationUtil.getExpirationDisplayValue(context, seconds);
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_disappearing_message_time_updated_to_s, time), R.drawable.ic_update_timer_16, defaultTint);
    } else if (MessageTypes.isIdentityUpdate(thread.getType())) {
      return emphasisAdded(recipientToStringAsync(thread.getRecipient().getId(), r -> {
        if (r.isGroup()) {
          return new SpannableString(context.getString(R.string.ThreadRecord_safety_number_changed));
        } else {
          return new SpannableString(context.getString(R.string.ThreadRecord_your_safety_number_with_s_has_changed, r.getDisplayName(context)));
        }
      }));
    } else if (MessageTypes.isIdentityVerified(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_you_marked_verified), defaultTint);
    } else if (MessageTypes.isIdentityDefault(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_you_marked_unverified), defaultTint);
    } else if (MessageTypes.isUnsupportedMessageType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_message_could_not_be_processed), defaultTint);
    } else if (MessageTypes.isProfileChange(thread.getType())) {
      return emphasisAdded(context, "", defaultTint);
    } else if (MessageTypes.isChangeNumber(thread.getType()) || MessageTypes.isBoostRequest(thread.getType())) {
      return emphasisAdded(context, "", defaultTint);
    } else if (MessageTypes.isBadDecryptType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_delivery_issue), defaultTint);
    } else if (MessageTypes.isThreadMergeType(thread.getType())) {
      return emphasisAdded(context, context.getString(R.string.ThreadRecord_message_history_has_been_merged), defaultTint);
    } else if (MessageTypes.isSessionSwitchoverType(thread.getType())) {
      if (thread.getRecipient().getE164().isPresent()) {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_s_belongs_to_s, PhoneNumberFormatter.prettyPrint(thread.getRecipient().requireE164()),  thread.getRecipient().getDisplayName(context)), defaultTint);
      } else {
        return emphasisAdded(context, context.getString(R.string.ThreadRecord_safety_number_changed), defaultTint);
      }
    } else {
      ThreadTable.Extra extra = thread.getExtra();
      if (extra != null && extra.isViewOnce()) {
        return emphasisAdded(context, getViewOnceDescription(context, thread.getContentType()), defaultTint);
      } else if (extra != null && extra.isRemoteDelete()) {
        return emphasisAdded(context, context.getString(thread.isOutgoing() ? R.string.ThreadRecord_you_deleted_this_message : R.string.ThreadRecord_this_message_was_deleted), defaultTint);
      } else {
        SpannableStringBuilder sourceBody = new SpannableStringBuilder(thread.getBody());
        MessageStyler.style(thread.getDate(), thread.getBodyRanges(), sourceBody);

        CharSequence              body      = StringUtil.replace(sourceBody, '\n', " ");
        LiveData<SpannableString> finalBody = Transformations.map(createFinalBodyWithMediaIcon(context, body, thread, glideRequests, thumbSize, thumbTarget), updatedBody -> {
          if (thread.getRecipient().isGroup()) {
            RecipientId groupMessageSender = thread.getGroupMessageSender();
            if (!groupMessageSender.isUnknown()) {
              return createGroupMessageUpdateString(context, updatedBody, Recipient.resolved(groupMessageSender));
            }
          }

          return new SpannableString(updatedBody);
        });

        return whileLoadingShow(sourceBody, finalBody);
      }
    }
  }

  private static LiveData<CharSequence> createFinalBodyWithMediaIcon(@NonNull Context context,
                                                                     @NonNull CharSequence body,
                                                                     @NonNull ThreadRecord thread,
                                                                     @NonNull GlideRequests glideRequests,
                                                                     @Px int thumbSize,
                                                                     @NonNull GlideLiveDataTarget thumbTarget)
  {
    if (thread.getSnippetUri() == null) {
      return LiveDataUtil.just(body);
    }

    final SpannableStringBuilder bodyWithoutMediaPrefix = SpannableStringBuilder.valueOf(body);

    if (StringUtil.startsWith(body, EmojiStrings.GIF)) {
      bodyWithoutMediaPrefix.replace(0, EmojiStrings.GIF.length(), "");
    } else if (StringUtil.startsWith(body, EmojiStrings.VIDEO)) {
      bodyWithoutMediaPrefix.replace(0, EmojiStrings.VIDEO.length(), "");
    } else if (StringUtil.startsWith(body, EmojiStrings.PHOTO)) {
      bodyWithoutMediaPrefix.replace(0, EmojiStrings.PHOTO.length(), "");
    } else if (thread.getExtra() != null && thread.getExtra().getStickerEmoji() != null && StringUtil.startsWith(body, thread.getExtra().getStickerEmoji())) {
      bodyWithoutMediaPrefix.replace(0, thread.getExtra().getStickerEmoji().length(), "");
    } else {
      return LiveDataUtil.just(body);
    }

    glideRequests.asBitmap()
                 .load(new DecryptableStreamUriLoader.DecryptableUri(thread.getSnippetUri()))
                 .override(thumbSize, thumbSize)
                 .transform(
                     new OverlayTransformation(ContextCompat.getColor(context, R.color.transparent_black_08)),
                     new CenterCrop()
                 )
                 .into(thumbTarget);

    return Transformations.map(thumbTarget.getLiveData(), bitmap -> {
      if (bitmap == null) {
        return body;
      }

      RoundedDrawable drawable = RoundedDrawable.fromBitmap(bitmap);
      drawable.setBounds(0, 0, thumbSize, thumbSize);
      drawable.setCornerRadius(DimensionUnit.DP.toPixels(2));
      drawable.setScaleType(ImageView.ScaleType.CENTER_INSIDE);

      CharSequence thumbnailSpan = SpanUtil.buildCenteredImageSpan(drawable);

      return new SpannableStringBuilder()
          .append(thumbnailSpan)
          .append(bodyWithoutMediaPrefix);
    });
  }

  private static SpannableString createGroupMessageUpdateString(@NonNull Context context,
                                                                @NonNull CharSequence body,
                                                                @NonNull Recipient recipient)
  {
    String sender = (recipient.isSelf() ? context.getString(R.string.MessageRecord_you)
                                        : recipient.getShortDisplayName(context)) + ": ";

    SpannableStringBuilder builder = new SpannableStringBuilder(sender).append(body);
    builder.setSpan(SpanUtil.getBoldSpan(),
                    0,
                    sender.length(),
                    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

    return new SpannableString(builder);
  }

  /**
   * After a short delay, if the main data hasn't shown yet, then a loading message is displayed.
   */
  private static @NonNull LiveData<SpannableString> whileLoadingShow(@NonNull CharSequence loading, @NonNull LiveData<SpannableString> string) {
    return LiveDataUtil.until(string, LiveDataUtil.delay(250, SpannableString.valueOf(loading)));
  }

  private static @NonNull LiveData<SpannableString> emphasisAdded(@NonNull Context context, @NonNull String string, @ColorInt int defaultTint) {
    return emphasisAdded(context, UpdateDescription.staticDescription(string, 0), defaultTint);
  }

  private static @NonNull LiveData<SpannableString> emphasisAdded(@NonNull Context context, @NonNull String string, @DrawableRes int iconResource, @ColorInt int defaultTint) {
    return emphasisAdded(context, UpdateDescription.staticDescription(string, iconResource), defaultTint);
  }

  private static @NonNull LiveData<SpannableString> emphasisAdded(@NonNull Context context, @NonNull UpdateDescription description, @ColorInt int defaultTint) {
    return emphasisAdded(LiveUpdateMessage.fromMessageDescription(context, description, defaultTint, false));
  }

  private static @NonNull LiveData<SpannableString> emphasisAdded(@NonNull LiveData<SpannableString> description) {
    return Transformations.map(description, sequence -> {
      SpannableString spannable = new SpannableString(sequence);
      spannable.setSpan(new StyleSpan(Typeface.ITALIC),
                        0,
                        sequence.length(),
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
      return spannable;
    });
  }

  private static String getViewOnceDescription(@NonNull Context context, @Nullable String contentType) {
    if (MediaUtil.isViewOnceType(contentType)) {
      return context.getString(R.string.ThreadRecord_view_once_media);
    } else if (MediaUtil.isVideoType(contentType)) {
      return context.getString(R.string.ThreadRecord_view_once_video);
    } else {
      return context.getString(R.string.ThreadRecord_view_once_photo);
    }
  }

  private void onDisplayBodyChanged(SpannableString spannableString) {
    setSubjectViewText(spannableString);

    if (typingThreads != null) {
      updateTypingIndicator(typingThreads);
    }
  }
}
