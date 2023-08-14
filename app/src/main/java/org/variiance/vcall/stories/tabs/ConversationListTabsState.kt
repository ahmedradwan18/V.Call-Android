package org.variiance.vcall.stories.tabs

data class ConversationListTabsState(
  val tab: ConversationListTab = ConversationListTab.CHATS,
  val prevTab: ConversationListTab = ConversationListTab.APPS,
  val unreadMessagesCount: Long = 0L,
  val unreadCallsCount: Long = 0L,
  val unreadDiscoverCount: Long = 0L,
  val unreadStoriesCount: Long = 0L,
  val unreadAppsCount: Long = 0L,
  val unreadRoomsCount: Long = 0L,
  val hasFailedStory: Boolean = false,
  val visibilityState: VisibilityState = VisibilityState()
) {
  data class VisibilityState(
    val isSearchOpen: Boolean = false,
    val isMultiSelectOpen: Boolean = false,
    val isShowingArchived: Boolean = false
  ) {
    fun isVisible(): Boolean {
      return !isSearchOpen && !isMultiSelectOpen && !isShowingArchived
    }
  }
}
