package org.variiance.vcall.testing

import org.junit.rules.TestWatcher
import org.junit.runner.Description
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.keyvalue.SignalStore
import org.whispersystems.signalservice.api.push.ACI
import org.whispersystems.signalservice.api.push.PNI
import java.util.UUID

/**
 * Sets up bare-minimum to allow writing unit tests against the database,
 * including setting up the local ACI and PNI pair.
 *
 * @param deleteAllThreadsOnEachRun Run deleteAllThreads between each unit test
 */
class SignalDatabaseRule(
  private val deleteAllThreadsOnEachRun: Boolean = true
) : TestWatcher() {

  val localAci: ACI = ACI.from(UUID.randomUUID())
  val localPni: PNI = PNI.from(UUID.randomUUID())

  override fun starting(description: Description?) {
    deleteAllThreads()

    SignalStore.account().setAci(localAci)
    SignalStore.account().setPni(localPni)
  }

  override fun finished(description: Description?) {
    deleteAllThreads()
  }

  private fun deleteAllThreads() {
    if (deleteAllThreadsOnEachRun) {
      SignalDatabase.threads.clearForTests()
    }
  }
}
