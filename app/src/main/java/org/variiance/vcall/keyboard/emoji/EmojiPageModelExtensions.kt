package org.variiance.vcall.keyboard.emoji

import org.variiance.vcall.components.emoji.EmojiPageModel
import org.variiance.vcall.components.emoji.EmojiPageViewGridAdapter
import org.variiance.vcall.components.emoji.RecentEmojiPageModel
import org.variiance.vcall.components.emoji.parsing.EmojiTree
import org.variiance.vcall.emoji.EmojiCategory
import org.variiance.vcall.emoji.EmojiSource
import org.variiance.vcall.util.adapter.mapping.MappingModel

fun EmojiPageModel.toMappingModels(): List<MappingModel<*>> {
  val emojiTree: EmojiTree = EmojiSource.latest.emojiTree

  return displayEmoji.map {
    val isTextEmoji = EmojiCategory.EMOTICONS.key == key || (RecentEmojiPageModel.KEY == key && emojiTree.getEmoji(it.value, 0, it.value.length) == null)

    if (isTextEmoji) {
      EmojiPageViewGridAdapter.EmojiTextModel(key, it)
    } else {
      EmojiPageViewGridAdapter.EmojiModel(key, it)
    }
  }
}
