package org.variiance.vcall.mediasend.camerax

import android.os.Build
import org.signal.core.util.asListContains
import org.variiance.vcall.util.FeatureFlags

/**
 * Some phones don't work well with CameraX. This class uses a remote config to decide
 * which phones should fall back to the legacy camera.
 */
object CameraXModelBlocklist {

  @JvmStatic
  fun isBlocklisted(): Boolean {
    return FeatureFlags.cameraXModelBlocklist().asListContains(Build.MODEL)
  }
}
