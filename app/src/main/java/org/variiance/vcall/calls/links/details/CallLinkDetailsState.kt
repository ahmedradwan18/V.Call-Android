/**
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.calls.links.details

import androidx.compose.runtime.Immutable
import org.variiance.vcall.database.CallLinkTable

@Immutable
data class CallLinkDetailsState(
  val displayRevocationDialog: Boolean = false,
  val callLink: CallLinkTable.CallLink? = null
)
