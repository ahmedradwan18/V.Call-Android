package org.variiance.vcall;

import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleOwner;

import org.variiance.vcall.conversationlist.model.ConversationSet;
import org.variiance.vcall.database.model.ThreadRecord;
import org.variiance.vcall.mms.GlideRequests;

import java.util.Locale;
import java.util.Set;

public interface BindableConversationListItem extends Unbindable {

  void bind(@NonNull LifecycleOwner lifecycleOwner,
            @NonNull ThreadRecord thread,
            @NonNull GlideRequests glideRequests, @NonNull Locale locale,
            @NonNull Set<Long> typingThreads,
            @NonNull ConversationSet selectedConversations);

  void setSelectedConversations(@NonNull ConversationSet conversations);
  void updateTypingIndicator(@NonNull Set<Long> typingThreads);
}
