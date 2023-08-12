package org.variiance.vcall.testutil

import android.net.Uri
import org.variiance.vcall.attachments.UriAttachment
import org.variiance.vcall.audio.AudioHash
import org.variiance.vcall.blurhash.BlurHash
import org.variiance.vcall.database.AttachmentTable
import org.variiance.vcall.stickers.StickerLocator

object UriAttachmentBuilder {
  fun build(
    id: Long,
    uri: Uri = Uri.parse("content://$id"),
    contentType: String,
    transferState: Int = AttachmentTable.TRANSFER_PROGRESS_PENDING,
    size: Long = 0L,
    fileName: String = "file$id",
    voiceNote: Boolean = false,
    borderless: Boolean = false,
    videoGif: Boolean = false,
    quote: Boolean = false,
    caption: String? = null,
    stickerLocator: StickerLocator? = null,
    blurHash: BlurHash? = null,
    audioHash: AudioHash? = null,
    transformProperties: AttachmentTable.TransformProperties? = null
  ): UriAttachment {
    return UriAttachment(
      uri,
      contentType,
      transferState,
      size,
      fileName,
      voiceNote,
      borderless,
      videoGif,
      quote,
      caption,
      stickerLocator,
      blurHash,
      audioHash,
      transformProperties
    )
  }
}
