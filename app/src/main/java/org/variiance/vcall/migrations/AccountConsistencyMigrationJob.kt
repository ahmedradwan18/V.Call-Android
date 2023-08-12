package org.variiance.vcall.migrations

import org.signal.core.util.logging.Log
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.jobs.AccountConsistencyWorkerJob
import org.variiance.vcall.keyvalue.SignalStore

/**
 * Migration to help address some account consistency issues that resulted under very specific situation post-device-transfer.
 */
internal class AccountConsistencyMigrationJob(
  parameters: Parameters = Parameters.Builder().build()
) : MigrationJob(parameters) {

  companion object {
    const val KEY = "AccountConsistencyMigrationJob"

    val TAG = Log.tag(AccountConsistencyMigrationJob::class.java)
  }

  override fun getFactoryKey(): String = KEY

  override fun isUiBlocking(): Boolean = false

  override fun performMigration() {
    if (!SignalStore.account().hasAciIdentityKey()) {
      Log.i(TAG, "No identity set yet, skipping.")
      return
    }

    if (!SignalStore.account().isRegistered || SignalStore.account().aci == null) {
      Log.i(TAG, "Not yet registered, skipping.")
      return
    }

    ApplicationDependencies.getJobManager().add(AccountConsistencyWorkerJob())
  }

  override fun shouldRetry(e: Exception): Boolean = false

  class Factory : Job.Factory<AccountConsistencyMigrationJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): AccountConsistencyMigrationJob {
      return AccountConsistencyMigrationJob(parameters)
    }
  }
}
