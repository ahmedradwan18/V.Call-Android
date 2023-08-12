package org.variiance.vcall.migrations

import org.signal.core.util.logging.Log
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.jobs.PushDecryptDrainedJob

/**
 * Kicks off a job to notify the [org.variiance.vcall.messages.IncomingMessageObserver] when the decryption queue is empty.
 */
internal class DecryptionsDrainedMigrationJob(
  parameters: Parameters = Parameters.Builder().build()
) : MigrationJob(parameters) {

  companion object {
    val TAG = Log.tag(DecryptionsDrainedMigrationJob::class.java)
    const val KEY = "DecryptionsDrainedMigrationJob"
  }

  override fun getFactoryKey(): String = KEY

  override fun isUiBlocking(): Boolean = false

  override fun performMigration() {
    ApplicationDependencies.getJobManager().add(PushDecryptDrainedJob())
  }

  override fun shouldRetry(e: Exception): Boolean = false

  class Factory : Job.Factory<DecryptionsDrainedMigrationJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): DecryptionsDrainedMigrationJob {
      return DecryptionsDrainedMigrationJob(parameters)
    }
  }
}
