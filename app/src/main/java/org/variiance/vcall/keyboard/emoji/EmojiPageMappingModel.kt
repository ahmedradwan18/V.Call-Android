package org.variiance.vcall.keyboard.emoji

import org.variiance.vcall.components.emoji.EmojiPageModel
import org.variiance.vcall.util.adapter.mapping.MappingModel

class EmojiPageMappingModel(val key: String, val emojiPageModel: EmojiPageModel) : MappingModel<EmojiPageMappingModel> {
  override fun areItemsTheSame(newItem: EmojiPageMappingModel): Boolean {
    return key == newItem.key
  }

  override fun areContentsTheSame(newItem: EmojiPageMappingModel): Boolean {
    return areItemsTheSame(newItem) &&
      newItem.emojiPageModel.spriteUri == emojiPageModel.spriteUri &&
      newItem.emojiPageModel.iconAttr == emojiPageModel.iconAttr
  }
}
