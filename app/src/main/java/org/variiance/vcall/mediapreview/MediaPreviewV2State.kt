package org.variiance.vcall.mediapreview

import android.text.SpannableString
import org.variiance.vcall.database.MediaTable
import org.variiance.vcall.mediasend.Media

data class MediaPreviewV2State(
  val mediaRecords: List<MediaTable.MediaRecord> = emptyList(),
  val loadState: LoadState = LoadState.INIT,
  val position: Int = 0,
  val showThread: Boolean = false,
  val allMediaInAlbumRail: Boolean = false,
  val leftIsRecent: Boolean = false,
  val albums: Map<Long, List<Media>> = mapOf(),
  val messageBodies: Map<Long, SpannableString> = mapOf(),
  val isInSharedAnimation: Boolean = true
) {
  enum class LoadState { INIT, DATA_LOADED, MEDIA_READY }
}
