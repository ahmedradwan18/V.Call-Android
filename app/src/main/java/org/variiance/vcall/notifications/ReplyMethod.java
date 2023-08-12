package org.variiance.vcall.notifications;

import android.content.Context;

import androidx.annotation.NonNull;

import org.variiance.vcall.database.RecipientTable;
import org.variiance.vcall.keyvalue.SignalStore;
import org.variiance.vcall.recipients.Recipient;

public enum ReplyMethod {

  GroupMessage,
  SecureMessage,
  UnsecuredSmsMessage;

  public static @NonNull ReplyMethod forRecipient(Context context, Recipient recipient) {
    if (recipient.isGroup()) {
      return ReplyMethod.GroupMessage;
    } else if (SignalStore.account().isRegistered() && recipient.getRegistered() == RecipientTable.RegisteredState.REGISTERED && !recipient.isForceSmsSelection()) {
      return ReplyMethod.SecureMessage;
    } else {
      return ReplyMethod.UnsecuredSmsMessage;
    }
  }
}
