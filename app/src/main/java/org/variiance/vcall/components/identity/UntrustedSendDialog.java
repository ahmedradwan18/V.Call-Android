package org.variiance.vcall.components.identity;


import android.content.Context;
import android.content.DialogInterface;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import org.variiance.vcall.R;
import org.variiance.vcall.crypto.ReentrantSessionLock;
import org.variiance.vcall.crypto.storage.SignalIdentityKeyStore;
import org.variiance.vcall.database.model.IdentityRecord;
import org.variiance.vcall.dependencies.ApplicationDependencies;
import org.signal.core.util.concurrent.SimpleTask;
import org.whispersystems.signalservice.api.SignalSessionLock;

import java.util.List;

public class UntrustedSendDialog extends AlertDialog.Builder implements DialogInterface.OnClickListener {

  private final List<IdentityRecord> untrustedRecords;
  private final ResendListener       resendListener;

  public UntrustedSendDialog(@NonNull Context context,
                             @NonNull String message,
                             @NonNull List<IdentityRecord> untrustedRecords,
                             @NonNull ResendListener resendListener)
  {
    super(context);
    this.untrustedRecords = untrustedRecords;
    this.resendListener   = resendListener;

    setTitle(R.string.UntrustedSendDialog_send_message);
    setIcon(R.drawable.ic_warning);
    setMessage(message);
    setPositiveButton(R.string.UntrustedSendDialog_send, this);
    setNegativeButton(android.R.string.cancel, null);
  }

  @Override
  public void onClick(DialogInterface dialog, int which) {
    final SignalIdentityKeyStore identityStore = ApplicationDependencies.getProtocolStore().aci().identities();

    SimpleTask.run(() -> {
      try(SignalSessionLock.Lock unused = ReentrantSessionLock.INSTANCE.acquire()) {
        for (IdentityRecord identityRecord : untrustedRecords) {
          identityStore.setApproval(identityRecord.getRecipientId(), true);
        }
      }

      return null;
    }, unused -> resendListener.onResendMessage());
  }

  public interface ResendListener {
    public void onResendMessage();
  }
}
