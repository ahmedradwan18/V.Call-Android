package org.variiance.vcall.groups.ui;

import androidx.annotation.NonNull;

import org.variiance.vcall.recipients.Recipient;

public interface RecipientClickListener {
  void onClick(@NonNull Recipient recipient);
}
