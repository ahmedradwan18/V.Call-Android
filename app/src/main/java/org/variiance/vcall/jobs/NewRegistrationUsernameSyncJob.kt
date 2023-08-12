package org.variiance.vcall.jobs

import org.signal.core.util.logging.Log
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.jobmanager.impl.NetworkConstraint
import java.io.IOException

/**
 * If a user registers and the storage sync service doesn't contain a username,
 * then we should delete our username from the server.
 */
class NewRegistrationUsernameSyncJob private constructor(parameters: Parameters) : BaseJob(parameters) {

  companion object {
    private val TAG = Log.tag(NewRegistrationUsernameSyncJob::class.java)

    const val KEY = "NewRegistrationUsernameSyncJob"
  }

  constructor() : this(
    Parameters.Builder()
      .setQueue(StorageSyncJob.QUEUE_KEY)
      .setMaxInstancesForFactory(1)
      .addConstraint(NetworkConstraint.KEY)
      .build()
  )

  override fun serialize(): ByteArray? = null

  override fun getFactoryKey(): String = KEY

  override fun onFailure() = Unit

  override fun onRun() {
    RefreshOwnProfileJob.checkUsernameIsInSync()
  }

  override fun onShouldRetry(e: Exception): Boolean {
    return e is IOException
  }

  class Factory : Job.Factory<NewRegistrationUsernameSyncJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): NewRegistrationUsernameSyncJob {
      return NewRegistrationUsernameSyncJob(parameters)
    }
  }
}
