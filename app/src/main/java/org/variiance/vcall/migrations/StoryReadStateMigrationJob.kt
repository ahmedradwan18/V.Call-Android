package org.variiance.vcall.migrations

import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.SignalDatabase.Companion.recipients
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.storage.StorageSyncHelper

/**
 * Added to initialize whether the user has seen the onboarding story
 */
internal class StoryReadStateMigrationJob(
  parameters: Parameters = Parameters.Builder().build()
) : MigrationJob(parameters) {

  companion object {
    const val KEY = "StoryReadStateMigrationJob"
  }

  override fun getFactoryKey(): String = KEY

  override fun isUiBlocking(): Boolean = false

  override fun performMigration() {
    if (!SignalStore.storyValues().hasUserOnboardingStoryReadBeenSet()) {
      SignalStore.storyValues().userHasReadOnboardingStory = SignalStore.storyValues().userHasReadOnboardingStory
      SignalDatabase.messages.markOnboardingStoryRead()

      if (SignalStore.account().isRegistered) {
        recipients.markNeedsSync(Recipient.self().id)
        StorageSyncHelper.scheduleSyncForDataChange()
      }
    }
  }

  override fun shouldRetry(e: Exception): Boolean = false

  class Factory : Job.Factory<StoryReadStateMigrationJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): StoryReadStateMigrationJob {
      return StoryReadStateMigrationJob(parameters)
    }
  }
}
