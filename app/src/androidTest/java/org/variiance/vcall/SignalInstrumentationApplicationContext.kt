package org.variiance.vcall

import org.signal.core.util.concurrent.SignalExecutors
import org.signal.core.util.logging.AndroidLogger
import org.signal.core.util.logging.Log
import org.signal.libsignal.protocol.logging.SignalProtocolLoggerProvider
import org.variiance.vcall.database.LogDatabase
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.dependencies.ApplicationDependencyProvider
import org.variiance.vcall.dependencies.InstrumentationApplicationDependencyProvider
import org.variiance.vcall.logging.CustomSignalProtocolLogger
import org.variiance.vcall.logging.PersistentLogger
import org.variiance.vcall.testing.InMemoryLogger

/**
 * Application context for running instrumentation tests (aka androidTests).
 */
class SignalInstrumentationApplicationContext : ApplicationContext() {

  val inMemoryLogger: InMemoryLogger = InMemoryLogger()

  override fun initializeAppDependencies() {
    val default = ApplicationDependencyProvider(this)
    ApplicationDependencies.init(this, InstrumentationApplicationDependencyProvider(this, default))
    ApplicationDependencies.getDeadlockDetector().start()
  }

  override fun initializeLogging() {
    persistentLogger = PersistentLogger(this)

    Log.initialize({ true }, AndroidLogger(), persistentLogger, inMemoryLogger)

    SignalProtocolLoggerProvider.setProvider(CustomSignalProtocolLogger())

    SignalExecutors.UNBOUNDED.execute {
      Log.blockUntilAllWritesFinished()
      LogDatabase.getInstance(this).trimToSize()
    }
  }
}
