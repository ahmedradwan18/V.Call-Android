package org.variiance.vcall.stories.settings.group

import org.variiance.vcall.recipients.Recipient

data class GroupStorySettingsState(
  val name: String = "",
  val members: List<Recipient> = emptyList(),
  val removed: Boolean = false
)
