package org.variiance.vcall.conversation.drafts

import android.content.Context
import android.net.Uri
import android.text.Spannable
import android.text.SpannableString
import io.reactivex.rxjava3.core.Maybe
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.signal.core.util.StreamUtil
import org.signal.core.util.concurrent.MaybeCompat
import org.signal.core.util.concurrent.SignalExecutors
import org.signal.core.util.logging.Log
import org.variiance.vcall.components.location.SignalPlace
import org.variiance.vcall.components.mention.MentionAnnotation
import org.variiance.vcall.conversation.ConversationIntents
import org.variiance.vcall.conversation.ConversationMessage
import org.variiance.vcall.conversation.ConversationMessage.ConversationMessageFactory
import org.variiance.vcall.conversation.MessageStyler
import org.variiance.vcall.database.DraftTable
import org.variiance.vcall.database.DraftTable.Drafts
import org.variiance.vcall.database.MentionUtil
import org.variiance.vcall.database.MessageTypes
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.ThreadTable
import org.variiance.vcall.database.adjustBodyRanges
import org.variiance.vcall.database.model.MediaMmsMessageRecord
import org.variiance.vcall.database.model.Mention
import org.variiance.vcall.database.model.MessageId
import org.variiance.vcall.database.model.MessageRecord
import org.variiance.vcall.database.model.databaseprotos.BodyRangeList
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.keyboard.KeyboardUtil
import org.variiance.vcall.mediasend.Media
import org.variiance.vcall.mms.GifSlide
import org.variiance.vcall.mms.GlideApp
import org.variiance.vcall.mms.ImageSlide
import org.variiance.vcall.mms.PartAuthority
import org.variiance.vcall.mms.QuoteId
import org.variiance.vcall.mms.Slide
import org.variiance.vcall.mms.SlideFactory
import org.variiance.vcall.mms.StickerSlide
import org.variiance.vcall.providers.BlobProvider
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.util.Base64
import org.variiance.vcall.util.MediaUtil
import org.variiance.vcall.util.concurrent.SerialMonoLifoExecutor
import org.variiance.vcall.util.hasTextSlide
import org.variiance.vcall.util.requireTextSlide
import java.io.IOException
import java.util.concurrent.Executor

class DraftRepository(
  private val context: Context = ApplicationDependencies.getApplication(),
  private val threadTable: ThreadTable = SignalDatabase.threads,
  private val draftTable: DraftTable = SignalDatabase.drafts,
  private val saveDraftsExecutor: Executor = SerialMonoLifoExecutor(SignalExecutors.BOUNDED),
  private val conversationArguments: ConversationIntents.Args? = null
) {

  companion object {
    val TAG = Log.tag(DraftRepository::class.java)
  }

  fun getShareOrDraftData(lastShareDataTimestamp: Long): Maybe<Pair<ShareOrDraftData?, Drafts?>> {
    return MaybeCompat.fromCallable { getShareOrDraftDataInternal(lastShareDataTimestamp) }
      .observeOn(Schedulers.io())
  }

  /**
   * Loads share data from the intent and draft data from the database and provides a one-spot initial
   * load of data.
   *
   * Note: Voice note drafts are handled differently and via the [DraftViewModel.state]
   */
  @Suppress("ConvertTwoComparisonsToRangeCheck")
  private fun getShareOrDraftDataInternal(lastShareDataTimestamp: Long): Pair<ShareOrDraftData?, Drafts?>? {
    val sharedDataTimestamp: Long = conversationArguments?.shareDataTimestamp ?: -1
    Log.d(TAG, "Shared this data at $sharedDataTimestamp and last processed share data at $lastShareDataTimestamp")
    if (sharedDataTimestamp > 0 && sharedDataTimestamp <= lastShareDataTimestamp) {
      Log.d(TAG, "Already processed this share data. Skipping.")
      return null
    } else {
      Log.d(TAG, "Have not processed this share data. Proceeding.")
    }

    val shareText = conversationArguments?.draftText
    val shareMedia = conversationArguments?.draftMedia
    val shareContentType = conversationArguments?.draftContentType
    val shareMediaType = conversationArguments?.draftMediaType
    val shareMediaList = conversationArguments?.media ?: emptyList()
    val stickerLocator = conversationArguments?.stickerLocator
    val borderless = conversationArguments?.isBorderless ?: false

    if (stickerLocator != null && shareMedia != null) {
      val slide = StickerSlide(context, shareMedia, 0, stickerLocator, shareContentType!!)
      return ShareOrDraftData.SendSticker(slide) to null
    }

    if (shareMedia != null && shareContentType != null && borderless) {
      val details = KeyboardUtil.getImageDetails(GlideApp.with(context), shareMedia)

      if (details == null || !details.hasTransparency) {
        return ShareOrDraftData.SetMedia(shareMedia, shareMediaType!!, null) to null
      }

      val slide: Slide? = if (MediaUtil.isGif(shareContentType)) {
        GifSlide(context, shareMedia, 0, details.width, details.height, true, null)
      } else if (MediaUtil.isImageType(shareContentType)) {
        ImageSlide(context, shareMedia, shareContentType, 0, details.width, details.height, true, null, null)
      } else {
        Log.w(TAG, "Attempting to send unsupported non-image via keyboard share")
        null
      }

      return if (slide != null) ShareOrDraftData.SendKeyboardImage(slide) to null else null
    }

    if (shareMediaList.isNotEmpty()) {
      return ShareOrDraftData.StartSendMedia(shareMediaList, shareText) to null
    }

    if (shareMedia != null && shareMediaType != null) {
      return ShareOrDraftData.SetMedia(shareMedia, shareMediaType, shareText) to null
    }

    if (shareText != null) {
      return ShareOrDraftData.SetText(shareText) to null
    }

    if (conversationArguments?.canInitializeFromDatabase() == true) {
      val (drafts, updatedText) = loadDraftsInternal(conversationArguments.threadId)

      val draftText: CharSequence? = drafts.firstOrNull { it.type == DraftTable.Draft.TEXT }?.let { updatedText ?: it.value }

      val location: SignalPlace? = drafts.firstOrNull { it.type == DraftTable.Draft.LOCATION }?.let { SignalPlace.deserialize(it.value) }
      if (location != null) {
        return ShareOrDraftData.SetLocation(location, draftText) to drafts
      }

      val quote: ConversationMessage? = drafts.firstOrNull { it.type == DraftTable.Draft.QUOTE }?.let { loadDraftQuoteInternal(it.value) }
      if (quote != null) {
        return ShareOrDraftData.SetQuote(quote, draftText) to drafts
      }

      val messageEdit: ConversationMessage? = drafts.firstOrNull { it.type == DraftTable.Draft.MESSAGE_EDIT }?.let { loadDraftMessageEditInternal(it.value) }
      if (messageEdit != null) {
        return ShareOrDraftData.SetEditMessage(messageEdit, draftText) to drafts
      }

      if (draftText != null) {
        return ShareOrDraftData.SetText(draftText) to drafts
      }

      return null to drafts
    }

    // no share or draft
    return null
  }

  fun deleteVoiceNoteDraftData(draft: DraftTable.Draft?) {
    if (draft != null) {
      SignalExecutors.BOUNDED.execute {
        BlobProvider.getInstance().delete(context, Uri.parse(draft.value).buildUpon().clearQuery().build())
      }
    }
  }

  fun saveDrafts(recipient: Recipient?, threadId: Long, distributionType: Int, drafts: Drafts) {
    require(threadId != -1L || recipient != null)

    saveDraftsExecutor.execute {
      if (drafts.isNotEmpty()) {
        val actualThreadId = if (threadId == -1L) {
          threadTable.getOrCreateThreadIdFor(recipient!!, distributionType)
        } else {
          threadId
        }

        draftTable.replaceDrafts(actualThreadId, drafts)
        if (drafts.shouldUpdateSnippet()) {
          threadTable.updateSnippet(actualThreadId, drafts.getSnippet(context), drafts.getUriSnippet(), System.currentTimeMillis(), MessageTypes.BASE_DRAFT_TYPE, true)
        } else {
          threadTable.update(actualThreadId, unarchive = false, allowDeletion = false)
        }
      } else if (threadId > 0) {
        draftTable.clearDrafts(threadId)
        threadTable.update(threadId, unarchive = false, allowDeletion = false)
      }
    }
  }

  @Deprecated("Not needed for CFv2")
  fun loadDrafts(threadId: Long): Single<DatabaseDraft> {
    return Single.fromCallable {
      loadDraftsInternal(threadId)
    }.subscribeOn(Schedulers.io())
  }

  private fun loadDraftsInternal(threadId: Long): DatabaseDraft {
    val drafts: Drafts = draftTable.getDrafts(threadId)
    val bodyRangesDraft: DraftTable.Draft? = drafts.getDraftOfType(DraftTable.Draft.BODY_RANGES)
    val textDraft: DraftTable.Draft? = drafts.getDraftOfType(DraftTable.Draft.TEXT)
    var updatedText: Spannable? = null

    if (textDraft != null && bodyRangesDraft != null) {
      val bodyRanges: BodyRangeList = BodyRangeList.parseFrom(Base64.decodeOrThrow(bodyRangesDraft.value))
      val mentions: List<Mention> = MentionUtil.bodyRangeListToMentions(bodyRanges)

      val updated = MentionUtil.updateBodyAndMentionsWithDisplayNames(context, textDraft.value, mentions)

      updatedText = SpannableString(updated.body)
      MentionAnnotation.setMentionAnnotations(updatedText, updated.mentions)
      MessageStyler.style(id = MessageStyler.DRAFT_ID, messageRanges = bodyRanges.adjustBodyRanges(updated.bodyAdjustments), span = updatedText, hideSpoilerText = false)
    }

    return DatabaseDraft(drafts, updatedText)
  }

  @Deprecated("Not needed for CFv2")
  fun loadDraftQuote(serialized: String): Maybe<ConversationMessage> {
    return MaybeCompat.fromCallable { loadDraftQuoteInternal(serialized) }
  }

  private fun loadDraftQuoteInternal(serialized: String): ConversationMessage? {
    val quoteId: QuoteId = QuoteId.deserialize(context, serialized) ?: return null
    val messageRecord: MessageRecord = SignalDatabase.messages.getMessageFor(quoteId.id, quoteId.author)?.let {
      if (it is MediaMmsMessageRecord) {
        it.withAttachments(context, SignalDatabase.attachments.getAttachmentsForMessage(it.id))
      } else {
        it
      }
    } ?: return null

    val threadRecipient = requireNotNull(SignalDatabase.threads.getRecipientForThreadId(messageRecord.threadId))
    return ConversationMessageFactory.createWithUnresolvedData(context, messageRecord, threadRecipient)
  }

  @Deprecated("Not needed for CFv2")
  fun loadDraftMessageEdit(serialized: String): Maybe<ConversationMessage> {
    return MaybeCompat.fromCallable { loadDraftMessageEditInternal(serialized) }
  }

  private fun loadDraftMessageEditInternal(serialized: String): ConversationMessage? {
    val messageId = MessageId.deserialize(serialized)
    val messageRecord: MessageRecord = SignalDatabase.messages.getMessageRecordOrNull(messageId.id) ?: return null
    val threadRecipient: Recipient = requireNotNull(SignalDatabase.threads.getRecipientForThreadId(messageRecord.threadId))
    if (messageRecord.hasTextSlide()) {
      val textSlide = messageRecord.requireTextSlide()
      if (textSlide.uri != null) {
        try {
          PartAuthority.getAttachmentStream(context, textSlide.uri!!).use { stream ->
            val body = StreamUtil.readFullyAsString(stream)
            return ConversationMessageFactory.createWithUnresolvedData(context, messageRecord, body, threadRecipient)
          }
        } catch (e: IOException) {
          Log.e(TAG, "Failed to load text slide", e)
        }
      }
    }
    return ConversationMessageFactory.createWithUnresolvedData(context, messageRecord, threadRecipient)
  }

  data class DatabaseDraft(val drafts: Drafts, val updatedText: CharSequence?)

  sealed interface ShareOrDraftData {
    data class SendSticker(val slide: Slide) : ShareOrDraftData
    data class SendKeyboardImage(val slide: Slide) : ShareOrDraftData
    data class StartSendMedia(val mediaList: List<Media>, val text: CharSequence?) : ShareOrDraftData
    data class SetMedia(val media: Uri, val mediaType: SlideFactory.MediaType, val text: CharSequence?) : ShareOrDraftData
    data class SetText(val text: CharSequence) : ShareOrDraftData
    data class SetLocation(val location: SignalPlace, val draftText: CharSequence?) : ShareOrDraftData
    data class SetQuote(val quote: ConversationMessage, val draftText: CharSequence?) : ShareOrDraftData
    data class SetEditMessage(val messageEdit: ConversationMessage, val draftText: CharSequence?) : ShareOrDraftData
  }
}
