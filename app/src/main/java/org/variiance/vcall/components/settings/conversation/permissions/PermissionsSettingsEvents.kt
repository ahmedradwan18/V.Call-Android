package org.variiance.vcall.components.settings.conversation.permissions

import org.variiance.vcall.groups.ui.GroupChangeFailureReason

sealed class PermissionsSettingsEvents {
  class GroupChangeError(val reason: GroupChangeFailureReason) : PermissionsSettingsEvents()
}
