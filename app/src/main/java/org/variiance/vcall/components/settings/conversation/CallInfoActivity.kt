package org.variiance.vcall.components.settings.conversation

import org.variiance.vcall.util.DynamicNoActionBarTheme
import org.variiance.vcall.util.DynamicTheme

class CallInfoActivity : ConversationSettingsActivity(), ConversationSettingsFragment.Callback {

  override val dynamicTheme: DynamicTheme = DynamicNoActionBarTheme()
}
