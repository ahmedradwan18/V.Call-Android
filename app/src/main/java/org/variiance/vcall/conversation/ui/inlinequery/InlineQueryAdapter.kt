package org.variiance.vcall.conversation.ui.inlinequery

import org.variiance.vcall.R
import org.variiance.vcall.util.adapter.mapping.AnyMappingModel
import org.variiance.vcall.util.adapter.mapping.MappingAdapter

class InlineQueryAdapter(listener: (AnyMappingModel) -> Unit) : MappingAdapter() {
  init {
    registerFactory(InlineQueryEmojiResult.Model::class.java, { InlineQueryEmojiResult.ViewHolder(it, listener) }, R.layout.inline_query_emoji_result)
  }
}
