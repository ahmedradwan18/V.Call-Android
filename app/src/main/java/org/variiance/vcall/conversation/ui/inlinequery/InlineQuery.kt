package org.variiance.vcall.conversation.ui.inlinequery

/**
 * Represents an inline query via compose text.
 */
sealed class InlineQuery(val query: String) {
  object NoQuery : InlineQuery("")
  class Emoji(query: String, val keywordSearch: Boolean) : InlineQuery(query.replace('_', ' '))
  class Mention(query: String) : InlineQuery(query)
}
