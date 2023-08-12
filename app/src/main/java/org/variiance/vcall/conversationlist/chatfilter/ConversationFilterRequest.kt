package org.variiance.vcall.conversationlist.chatfilter

import org.variiance.vcall.conversationlist.model.ConversationFilter

data class ConversationFilterRequest(
  val filter: ConversationFilter,
  val source: ConversationFilterSource
)
