package org.variiance.vcall.conversation.mutiselect

import android.view.View
import android.view.ViewGroup
import org.variiance.vcall.conversation.ConversationMessage
import org.variiance.vcall.conversation.colors.Colorizable
import org.variiance.vcall.giph.mp4.GiphyMp4Playable

/**
 * Describes a ConversationElement that can be included in multiselect mode.
 */
interface Multiselectable : Colorizable, GiphyMp4Playable {
  val conversationMessage: ConversationMessage
  val root: ViewGroup

  /**
   * For a given multiselect part, return the 'top' boundary of its corresponding region.
   * This is required even if there is only a single region for the given message.
   */
  fun getTopBoundaryOfMultiselectPart(multiselectPart: MultiselectPart): Int

  /**
   * For a given multiselect part, return the 'bottom' boundary of its corresponding region.
   * This is required even if there is only a single region for the given message.
   */
  fun getBottomBoundaryOfMultiselectPart(multiselectPart: MultiselectPart): Int

  /**
   * See [ConversationItem] for an implementation. This should return the part relative
   * to the last "down" touch point, relative to the Y-Axis.
   */
  fun getMultiselectPartForLatestTouch(): MultiselectPart

  /**
   * Gets the start-most view that we should translate to make room for the multiselect circle.
   * Only relevant for incoming messages.
   */
  fun getHorizontalTranslationTarget(): View?

  /**
   * Allows an item to denote itself as non-selectable, even though it implements this interface.
   */
  fun hasNonSelectableMedia(): Boolean
}
