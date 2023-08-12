package org.variiance.vcall.components.emoji.parsing

import org.variiance.vcall.emoji.EmojiPage

data class EmojiDrawInfo(val page: EmojiPage, val index: Int, private val emoji: String, val rawEmoji: String?, val jumboSheet: String?)
