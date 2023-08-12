package org.variiance.vcall.util;

import androidx.annotation.StyleRes;

import org.variiance.vcall.R;

public class DynamicRegistrationTheme extends DynamicTheme {

  protected @StyleRes int getTheme() {
    return R.style.Signal_DayNight_Registration;
  }
}
