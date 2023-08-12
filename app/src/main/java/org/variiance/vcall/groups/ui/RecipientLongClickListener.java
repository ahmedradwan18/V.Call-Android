package org.variiance.vcall.groups.ui;

import androidx.annotation.NonNull;

import org.variiance.vcall.recipients.Recipient;

public interface RecipientLongClickListener {
  boolean onLongClick(@NonNull Recipient recipient);
}
