package org.variiance.vcall.components.reminder;

import android.content.Context;

import org.variiance.vcall.R;
import org.variiance.vcall.keyvalue.SignalStore;
import org.variiance.vcall.registration.RegistrationNavigationActivity;

public class PushRegistrationReminder extends Reminder {

  public PushRegistrationReminder(final Context context) {
    super(R.string.reminder_header_push_title, R.string.reminder_header_push_text);

    setOkListener(v -> context.startActivity(RegistrationNavigationActivity.newIntentForReRegistration(context)));
  }

  @Override
  public boolean isDismissable() {
    return false;
  }

  public static boolean isEligible() {
    return !SignalStore.account().isRegistered();
  }
}
