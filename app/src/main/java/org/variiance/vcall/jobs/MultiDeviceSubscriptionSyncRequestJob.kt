package org.variiance.vcall.jobs

import org.signal.core.util.logging.Log
import org.variiance.vcall.crypto.UnidentifiedAccessUtil
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.jobmanager.impl.NetworkConstraint
import org.variiance.vcall.net.NotPushRegisteredException
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.util.TextSecurePreferences
import org.whispersystems.signalservice.api.messages.multidevice.SignalServiceSyncMessage
import org.whispersystems.signalservice.api.push.exceptions.PushNetworkException
import org.whispersystems.signalservice.api.push.exceptions.ServerRejectedException

/**
 * Sends a sync message to linked devices to notify them to refresh subscription status.
 */
class MultiDeviceSubscriptionSyncRequestJob private constructor(parameters: Parameters) : BaseJob(parameters) {

  companion object {
    const val KEY = "MultiDeviceSubscriptionSyncRequestJob"

    private val TAG = Log.tag(MultiDeviceSubscriptionSyncRequestJob::class.java)

    @JvmStatic
    fun enqueue() {
      val job = MultiDeviceSubscriptionSyncRequestJob(
        Parameters.Builder()
          .setQueue("MultiDeviceSubscriptionSyncRequestJob")
          .setMaxInstancesForFactory(2)
          .addConstraint(NetworkConstraint.KEY)
          .setMaxAttempts(10)
          .build()
      )

      ApplicationDependencies.getJobManager().add(job)
    }
  }

  override fun serialize(): ByteArray? = null

  override fun getFactoryKey(): String = KEY

  override fun onFailure() {
    Log.w(TAG, "Did not succeed!")
  }

  override fun onRun() {
    if (!Recipient.self().isRegistered) {
      throw NotPushRegisteredException()
    }

    if (!TextSecurePreferences.isMultiDevice(context)) {
      Log.i(TAG, "Not multi device, aborting...")
      return
    }

    val messageSender = ApplicationDependencies.getSignalServiceMessageSender()

    messageSender.sendSyncMessage(
      SignalServiceSyncMessage.forFetchLatest(SignalServiceSyncMessage.FetchType.SUBSCRIPTION_STATUS),
      UnidentifiedAccessUtil.getAccessForSync(context)
    )
  }

  override fun onShouldRetry(e: Exception): Boolean {
    return e is PushNetworkException && e !is ServerRejectedException
  }

  class Factory : Job.Factory<MultiDeviceSubscriptionSyncRequestJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): MultiDeviceSubscriptionSyncRequestJob {
      return MultiDeviceSubscriptionSyncRequestJob(parameters)
    }
  }
}
