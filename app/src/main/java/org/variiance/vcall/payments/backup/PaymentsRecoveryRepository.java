package org.variiance.vcall.payments.backup;

import androidx.annotation.NonNull;

import org.variiance.vcall.keyvalue.SignalStore;
import org.variiance.vcall.payments.Mnemonic;

public final class PaymentsRecoveryRepository {
  public @NonNull Mnemonic getMnemonic() {
    return SignalStore.paymentsValues().getPaymentsMnemonic();
  }
}
