package org.variiance.vcall.components.settings.app.appearance

import android.app.Activity
import androidx.lifecycle.ViewModel
import io.reactivex.rxjava3.core.Flowable
import org.variiance.vcall.jobs.EmojiSearchIndexDownloadJob
import org.variiance.vcall.keyvalue.SettingsValues.Theme
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.util.SplashScreenUtil
import org.variiance.vcall.util.rx.RxStore

class AppearanceSettingsViewModel : ViewModel() {
  private val store = RxStore(getState())
  val state: Flowable<AppearanceSettingsState> = store.stateFlowable

  override fun onCleared() {
    super.onCleared()
    store.dispose()
  }

  fun refreshState() {
    store.update { getState() }
  }

  fun setTheme(activity: Activity?, theme: Theme) {
    store.update { it.copy(theme = theme) }
    SignalStore.settings().theme = theme
    SplashScreenUtil.setSplashScreenThemeIfNecessary(activity, theme)
  }

  fun setLanguage(language: String) {
    store.update { it.copy(language = language) }
    SignalStore.settings().language = language
    EmojiSearchIndexDownloadJob.scheduleImmediately()
  }

  fun setMessageFontSize(size: Int) {
    store.update { it.copy(messageFontSize = size) }
    SignalStore.settings().messageFontSize = size
  }

  private fun getState(): AppearanceSettingsState {
    return AppearanceSettingsState(
      SignalStore.settings().theme,
      SignalStore.settings().messageFontSize,
      SignalStore.settings().language,
      SignalStore.settings().useCompactNavigationBar
    )
  }
}
