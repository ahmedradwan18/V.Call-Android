package org.variiance.vcall.conversation.ui.mentions;

import androidx.annotation.NonNull;

import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.util.viewholders.RecipientMappingModel;

public final class MentionViewState extends RecipientMappingModel<MentionViewState> {

  private final Recipient recipient;

  public MentionViewState(@NonNull Recipient recipient) {
    this.recipient = recipient;
  }

  @Override
  public @NonNull Recipient getRecipient() {
    return recipient;
  }
}
