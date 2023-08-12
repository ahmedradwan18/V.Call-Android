package org.variiance.vcall.components.settings.conversation.sounds

import android.content.Context
import org.signal.core.util.concurrent.SignalExecutors
import org.variiance.vcall.database.RecipientTable
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.notifications.NotificationChannels
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId

class SoundsAndNotificationsSettingsRepository(private val context: Context) {

  fun ensureCustomChannelConsistency(complete: () -> Unit) {
    SignalExecutors.BOUNDED.execute {
      if (NotificationChannels.supported()) {
        NotificationChannels.getInstance().ensureCustomChannelConsistency()
      }
      complete()
    }
  }

  fun setMuteUntil(recipientId: RecipientId, muteUntil: Long) {
    SignalExecutors.BOUNDED.execute {
      SignalDatabase.recipients.setMuted(recipientId, muteUntil)
    }
  }

  fun setMentionSetting(recipientId: RecipientId, mentionSetting: RecipientTable.MentionSetting) {
    SignalExecutors.BOUNDED.execute {
      SignalDatabase.recipients.setMentionSetting(recipientId, mentionSetting)
    }
  }

  fun hasCustomNotificationSettings(recipientId: RecipientId, consumer: (Boolean) -> Unit) {
    SignalExecutors.BOUNDED.execute {
      val recipient = Recipient.resolved(recipientId)
      consumer(
        if (recipient.notificationChannel != null || !NotificationChannels.supported()) {
          true
        } else {
          NotificationChannels.getInstance().updateWithShortcutBasedChannel(recipient)
        }
      )
    }
  }
}
