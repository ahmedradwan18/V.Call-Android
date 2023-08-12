package org.variiance.vcall.stories.viewer.views

import org.variiance.vcall.recipients.Recipient

data class StoryViewItemData(
  val recipient: Recipient,
  val timeViewedInMillis: Long
)
