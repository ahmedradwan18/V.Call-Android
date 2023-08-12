/*
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.conversation

import org.variiance.vcall.conversation.mutiselect.MultiselectPart

/**
 * Temporary shared interface between the two conversation adapters strictly for use in
 * shared decorators and other utils.
 */
interface ConversationAdapterBridge {
  fun hasNoConversationMessages(): Boolean
  fun getConversationMessage(position: Int): ConversationMessage?
  fun consumePulseRequest(): PulseRequest?

  val selectedItems: Set<MultiselectPart>

  data class PulseRequest(val position: Int, val isOutgoing: Boolean)
}
