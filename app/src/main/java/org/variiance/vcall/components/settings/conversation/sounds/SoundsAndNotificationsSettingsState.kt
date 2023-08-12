package org.variiance.vcall.components.settings.conversation.sounds

import org.variiance.vcall.database.RecipientTable
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.recipients.RecipientId

data class SoundsAndNotificationsSettingsState(
  val recipientId: RecipientId = Recipient.UNKNOWN.id,
  val muteUntil: Long = 0L,
  val mentionSetting: RecipientTable.MentionSetting = RecipientTable.MentionSetting.DO_NOT_NOTIFY,
  val hasCustomNotificationSettings: Boolean = false,
  val hasMentionsSupport: Boolean = false,
  val channelConsistencyCheckComplete: Boolean = false
)
