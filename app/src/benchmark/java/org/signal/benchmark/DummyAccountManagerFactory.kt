package org.signal.benchmark

import android.content.Context
import org.variiance.vcall.BuildConfig
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.push.AccountManagerFactory
import org.variiance.vcall.util.FeatureFlags
import org.whispersystems.signalservice.api.SignalServiceAccountManager
import org.whispersystems.signalservice.api.account.PreKeyUpload
import org.whispersystems.signalservice.api.push.ACI
import org.whispersystems.signalservice.api.push.PNI
import org.whispersystems.signalservice.internal.configuration.SignalServiceConfiguration
import java.io.IOException
import java.util.Optional

class DummyAccountManagerFactory : AccountManagerFactory() {
  override fun createAuthenticated(context: Context, aci: ACI, pni: PNI, number: String, deviceId: Int, password: String): SignalServiceAccountManager {
    return DummyAccountManager(
      ApplicationDependencies.getSignalServiceNetworkAccess().getConfiguration(number),
      aci,
      pni,
      number,
      deviceId,
      password,
      BuildConfig.SIGNAL_AGENT,
      FeatureFlags.okHttpAutomaticRetry(),
      FeatureFlags.groupLimits().hardLimit
    )
  }

  private class DummyAccountManager(configuration: SignalServiceConfiguration?, aci: ACI?, pni: PNI?, e164: String?, deviceId: Int, password: String?, signalAgent: String?, automaticNetworkRetry: Boolean, maxGroupSize: Int) : SignalServiceAccountManager(configuration, aci, pni, e164, deviceId, password, signalAgent, automaticNetworkRetry, maxGroupSize) {
    @Throws(IOException::class)
    override fun setGcmId(gcmRegistrationId: Optional<String>) {
    }

    @Throws(IOException::class)
    override fun setPreKeys(preKeyUpload: PreKeyUpload) {
    }
  }
}
