package org.variiance.vcall.keyboard.emoji

import android.content.Context
import org.signal.core.util.concurrent.SignalExecutors
import org.variiance.vcall.components.emoji.EmojiPageModel
import org.variiance.vcall.components.emoji.RecentEmojiPageModel
import org.variiance.vcall.emoji.EmojiSource.Companion.latest
import org.variiance.vcall.util.TextSecurePreferences
import java.util.function.Consumer

class EmojiKeyboardPageRepository(private val context: Context) {
  fun getEmoji(consumer: Consumer<List<EmojiPageModel>>) {
    SignalExecutors.BOUNDED.execute {
      val list = mutableListOf<EmojiPageModel>()
      list += RecentEmojiPageModel(context, TextSecurePreferences.RECENT_STORAGE_KEY)
      list += latest.displayPages
      consumer.accept(list)
    }
  }
}
