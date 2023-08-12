package org.variiance.vcall.mediasend.v2

import android.net.Uri
import org.variiance.vcall.conversation.MessageSendType
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.mediasend.Media
import org.variiance.vcall.mediasend.MediaSendConstants
import org.variiance.vcall.mms.SentMediaQuality
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.stories.Stories
import org.variiance.vcall.util.FeatureFlags

data class MediaSelectionState(
  val sendType: MessageSendType,
  val selectedMedia: List<Media> = listOf(),
  val focusedMedia: Media? = null,
  val recipient: Recipient? = null,
  val quality: SentMediaQuality = SignalStore.settings().sentMediaQuality,
  val message: CharSequence? = null,
  val viewOnceToggleState: ViewOnceToggleState = ViewOnceToggleState.INFINITE,
  val isTouchEnabled: Boolean = true,
  val isSent: Boolean = false,
  val isPreUploadEnabled: Boolean = false,
  val isMeteredConnection: Boolean = false,
  val editorStateMap: Map<Uri, Any> = mapOf(),
  val cameraFirstCapture: Media? = null,
  val isStory: Boolean,
  val storySendRequirements: Stories.MediaTransform.SendRequirements = Stories.MediaTransform.SendRequirements.CAN_NOT_SEND,
  val suppressEmptyError: Boolean = true
) {

  val maxSelection = if (sendType.usesSmsTransport) {
    MediaSendConstants.MAX_SMS
  } else {
    FeatureFlags.maxAttachmentCount()
  }

  val canSend = !isSent && selectedMedia.isNotEmpty()

  enum class ViewOnceToggleState(val code: Int) {
    INFINITE(0),
    ONCE(1);

    fun next(): ViewOnceToggleState {
      return when (this) {
        INFINITE -> ONCE
        ONCE -> INFINITE
      }
    }

    companion object {
      fun fromCode(code: Int): ViewOnceToggleState {
        return when (code) {
          1 -> ONCE
          else -> INFINITE
        }
      }
    }
  }
}
