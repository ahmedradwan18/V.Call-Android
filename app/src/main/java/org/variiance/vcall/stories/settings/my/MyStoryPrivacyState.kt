package org.variiance.vcall.stories.settings.my

import org.variiance.vcall.database.model.DistributionListPrivacyMode

data class MyStoryPrivacyState(val privacyMode: DistributionListPrivacyMode? = null, val connectionCount: Int = 0)
