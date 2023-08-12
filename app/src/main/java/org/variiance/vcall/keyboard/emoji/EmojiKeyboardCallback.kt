package org.variiance.vcall.keyboard.emoji

import org.variiance.vcall.components.emoji.EmojiEventListener
import org.variiance.vcall.keyboard.emoji.search.EmojiSearchFragment

interface EmojiKeyboardCallback :
  EmojiEventListener,
  EmojiKeyboardPageFragment.Callback,
  EmojiSearchFragment.Callback
