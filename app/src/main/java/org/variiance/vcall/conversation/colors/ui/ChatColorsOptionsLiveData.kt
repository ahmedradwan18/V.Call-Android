package org.variiance.vcall.conversation.colors.ui

import androidx.lifecycle.LiveData
import org.signal.core.util.concurrent.SignalExecutors
import org.variiance.vcall.conversation.colors.ChatColors
import org.variiance.vcall.conversation.colors.ChatColorsPalette
import org.variiance.vcall.database.ChatColorsTable
import org.variiance.vcall.database.DatabaseObserver
import org.variiance.vcall.database.SignalDatabase
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.util.concurrent.SerialMonoLifoExecutor
import java.util.concurrent.Executor

class ChatColorsOptionsLiveData : LiveData<List<ChatColors>>() {
  private val chatColorsTable: ChatColorsTable = SignalDatabase.chatColors
  private val observer: DatabaseObserver.Observer = DatabaseObserver.Observer { refreshChatColors() }
  private val executor: Executor = SerialMonoLifoExecutor(SignalExecutors.BOUNDED)

  override fun onActive() {
    refreshChatColors()
    ApplicationDependencies.getDatabaseObserver().registerChatColorsObserver(observer)
  }

  override fun onInactive() {
    ApplicationDependencies.getDatabaseObserver().unregisterObserver(observer)
  }

  private fun refreshChatColors() {
    executor.execute {
      val options = mutableListOf<ChatColors>().apply {
        addAll(ChatColorsPalette.Bubbles.all)
        addAll(chatColorsTable.getSavedChatColors())
      }

      postValue(options)
    }
  }
}
