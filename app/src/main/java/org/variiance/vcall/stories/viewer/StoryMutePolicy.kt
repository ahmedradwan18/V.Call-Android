package org.variiance.vcall.stories.viewer

import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.util.AppForegroundObserver

/**
 * Stories are to start muted, and once unmuted, remain as such until the
 * user backgrounds the application.
 */
object StoryMutePolicy : AppForegroundObserver.Listener {
  var isContentMuted: Boolean = true

  fun initialize() {
    ApplicationDependencies.getAppForegroundObserver().addListener(this)
  }

  override fun onBackground() {
    isContentMuted = true
  }
}
