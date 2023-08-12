package org.variiance.vcall.jobs

import android.os.Build
import androidx.annotation.RequiresApi
import org.signal.core.util.concurrent.safeBlockingGet
import org.signal.core.util.logging.Log
import org.variiance.vcall.attachments.AttachmentId
import org.variiance.vcall.attachments.DatabaseAttachment
import org.variiance.vcall.audio.AudioWaveForms
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobmanager.Job
import org.variiance.vcall.jobmanager.JsonJobData
import org.variiance.vcall.util.MediaUtil
import kotlin.time.Duration.Companion.days

/**
 * Generate and save wave form for an audio attachment.
 */
class GenerateAudioWaveFormJob private constructor(private val attachmentId: AttachmentId, parameters: Parameters) : BaseJob(parameters) {

  companion object {
    private val TAG = Log.tag(GenerateAudioWaveFormJob::class.java)

    private const val KEY_PART_ROW_ID = "part_row_id"
    private const val KEY_PAR_UNIQUE_ID = "part_unique_id"

    const val KEY = "GenerateAudioWaveFormJob"

    @JvmStatic
    fun enqueue(attachmentId: AttachmentId) {
      if (Build.VERSION.SDK_INT < 23) {
        Log.i(TAG, "Unable to generate waveform on this version of Android")
      } else {
        ApplicationDependencies.getJobManager().add(GenerateAudioWaveFormJob(attachmentId))
      }
    }
  }

  private constructor(attachmentId: AttachmentId) : this(
    attachmentId,
    Parameters.Builder()
      .setQueue("GenerateAudioWaveFormJob")
      .setLifespan(1.days.inWholeMilliseconds)
      .setMaxAttempts(1)
      .build()
  )

  override fun serialize(): ByteArray? {
    return JsonJobData.Builder()
      .putLong(KEY_PART_ROW_ID, attachmentId.rowId)
      .putLong(KEY_PAR_UNIQUE_ID, attachmentId.uniqueId)
      .serialize()
  }

  override fun getFactoryKey(): String = KEY

  @RequiresApi(23)
  override fun onRun() {
    val attachment: DatabaseAttachment? = SignalDatabase.attachments.getAttachment(attachmentId)

    if (attachment == null) {
      Log.i(TAG, "Unable to find attachment in database.")
      return
    }

    if (!MediaUtil.isAudio(attachment)) {
      Log.w(TAG, "Attempting to generate wave form for a non-audio attachment type: ${attachment.contentType}")
      return
    }

    try {
      AudioWaveForms
        .getWaveForm(context, attachment)
        .safeBlockingGet()

      Log.i(TAG, "Generation successful")
    } catch (e: Exception) {
      Log.i(TAG, "Generation failed", e)
    }
  }

  override fun onShouldRetry(e: Exception): Boolean {
    return false
  }

  override fun onFailure() = Unit

  class Factory : Job.Factory<GenerateAudioWaveFormJob> {
    override fun create(parameters: Parameters, serializedData: ByteArray?): GenerateAudioWaveFormJob {
      val data = JsonJobData.deserialize(serializedData)
      return GenerateAudioWaveFormJob(AttachmentId(data.getLong(KEY_PART_ROW_ID), data.getLong(KEY_PAR_UNIQUE_ID)), parameters)
    }
  }
}
