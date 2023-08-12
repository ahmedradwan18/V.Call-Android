package org.variiance.vcall.stories.viewer.post

import android.graphics.Typeface
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.database.model.MmsMessageRecord
import org.variiance.vcall.database.model.databaseprotos.StoryTextPost
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.fonts.TextFont
import org.variiance.vcall.fonts.TextToScript
import org.variiance.vcall.fonts.TypefaceCache
import org.variiance.vcall.util.Base64

class StoryTextPostRepository {
  fun getRecord(recordId: Long): Single<MmsMessageRecord> {
    return Single.fromCallable {
      SignalDatabase.messages.getMessageRecord(recordId) as MmsMessageRecord
    }.subscribeOn(Schedulers.io())
  }

  fun getTypeface(recordId: Long): Single<Typeface> {
    return getRecord(recordId).flatMap {
      val model = StoryTextPost.parseFrom(Base64.decode(it.body))
      val textFont = TextFont.fromStyle(model.style)
      val script = TextToScript.guessScript(model.body)

      TypefaceCache.get(ApplicationDependencies.getApplication(), textFont, script)
    }
  }
}
