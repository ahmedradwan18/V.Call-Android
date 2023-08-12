package org.variiance.vcall.deeplinks;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import org.variiance.vcall.MainActivity;
import org.variiance.vcall.PassphraseRequiredActivity;

public class DeepLinkEntryActivity extends PassphraseRequiredActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState, boolean ready) {
    Intent intent = MainActivity.clearTop(this);
    Uri    data   = getIntent().getData();
    intent.setData(data);
    startActivity(intent);
  }
}
