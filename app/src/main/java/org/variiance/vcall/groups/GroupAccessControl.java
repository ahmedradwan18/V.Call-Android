package org.variiance.vcall.groups;

import androidx.annotation.StringRes;

import org.variiance.vcall.R;

public enum GroupAccessControl {
  ALL_MEMBERS(R.string.GroupManagement_access_level_all_members),
  ONLY_ADMINS(R.string.GroupManagement_access_level_only_admins),
  NO_ONE(R.string.GroupManagement_access_level_no_one);

  private final @StringRes int string;

  GroupAccessControl(@StringRes int string) {
    this.string = string;
  }

  public @StringRes int getString() {
    return string;
  }
}
