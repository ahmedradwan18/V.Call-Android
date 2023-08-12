package org.variiance.vcall.util

import android.content.Context
import android.content.pm.PackageManager
import org.signal.core.util.logging.Log
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobs.RefreshAttributesJob
import org.variiance.vcall.jobs.RemoteConfigRefreshJob
import org.variiance.vcall.jobs.RetrieveRemoteAnnouncementsJob
import org.variiance.vcall.keyvalue.SignalStore
import java.time.Duration

object VersionTracker {
  private val TAG = Log.tag(VersionTracker::class.java)

  @JvmStatic
  fun getLastSeenVersion(context: Context): Int {
    return TextSecurePreferences.getLastVersionCode(context)
  }

  @JvmStatic
  fun updateLastSeenVersion(context: Context) {
    val currentVersionCode = Util.getCanonicalVersionCode()
    val lastVersionCode = TextSecurePreferences.getLastVersionCode(context)

    if (currentVersionCode != lastVersionCode) {
      Log.i(TAG, "Upgraded from $lastVersionCode to $currentVersionCode")
      SignalStore.misc().clearClientDeprecated()
      val jobChain = listOf(RemoteConfigRefreshJob(), RefreshAttributesJob())
      ApplicationDependencies.getJobManager().startChain(jobChain).enqueue()
      RetrieveRemoteAnnouncementsJob.enqueue(true)
      LocalMetrics.getInstance().clear()
    }

    TextSecurePreferences.setLastVersionCode(context, currentVersionCode)
  }

  @JvmStatic
  fun getDaysSinceFirstInstalled(context: Context): Long {
    return try {
      val installTimestamp = context.packageManager.getPackageInfo(context.packageName, 0).firstInstallTime
      Duration.ofMillis(System.currentTimeMillis() - installTimestamp).toDays()
    } catch (e: PackageManager.NameNotFoundException) {
      Log.w(TAG, e)
      0
    }
  }
}
