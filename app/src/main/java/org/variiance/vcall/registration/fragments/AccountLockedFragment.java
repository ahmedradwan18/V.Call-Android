package org.variiance.vcall.registration.fragments;

import androidx.lifecycle.ViewModelProvider;

import org.variiance.vcall.R;
import org.variiance.vcall.registration.viewmodel.BaseRegistrationViewModel;
import org.variiance.vcall.registration.viewmodel.RegistrationViewModel;

public class AccountLockedFragment extends BaseAccountLockedFragment {

  public AccountLockedFragment() {
    super(R.layout.account_locked_fragment);
  }

  @Override
  protected BaseRegistrationViewModel getViewModel() {
    return new ViewModelProvider(requireActivity()).get(RegistrationViewModel.class);
  }

  @Override
  protected void onNext() {
    requireActivity().finish();
  }
}
