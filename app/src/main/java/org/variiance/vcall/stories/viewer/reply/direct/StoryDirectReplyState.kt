package org.variiance.vcall.stories.viewer.reply.direct

import org.variiance.vcall.database.model.MessageRecord
import org.variiance.vcall.recipients.Recipient

data class StoryDirectReplyState(
  val groupDirectReplyRecipient: Recipient? = null,
  val storyRecord: MessageRecord? = null
)
