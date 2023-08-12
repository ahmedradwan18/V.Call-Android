package org.variiance.vcall.stories.settings.group

import android.view.MenuItem
import android.view.ViewGroup
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import io.reactivex.rxjava3.kotlin.subscribeBy
import org.signal.core.util.concurrent.LifecycleDisposable
import org.signal.core.util.dp
import org.variiance.vcall.R
import org.variiance.vcall.components.menu.ActionItem
import org.variiance.vcall.components.menu.SignalContextMenu
import org.variiance.vcall.components.settings.DSLConfiguration
import org.variiance.vcall.components.settings.DSLSettingsFragment
import org.variiance.vcall.components.settings.DSLSettingsText
import org.variiance.vcall.components.settings.configure
import org.variiance.vcall.conversation.ConversationIntents
import org.variiance.vcall.stories.dialogs.StoryDialogs
import org.variiance.vcall.stories.settings.custom.PrivateStoryItem
import org.variiance.vcall.util.adapter.mapping.MappingAdapter

/**
 * Displays who can see a group story and gives the user an option to remove it.
 */
class GroupStorySettingsFragment : DSLSettingsFragment(menuId = R.menu.story_group_menu) {

  private val lifecycleDisposable = LifecycleDisposable()

  private val viewModel: GroupStorySettingsViewModel by viewModels(factoryProducer = {
    GroupStorySettingsViewModel.Factory(GroupStorySettingsFragmentArgs.fromBundle(requireArguments()).groupId)
  })

  override fun onOptionsItemSelected(item: MenuItem): Boolean {
    val toolbar: Toolbar = requireView().findViewById(R.id.toolbar)
    if (item.itemId == R.id.action_overflow) {
      SignalContextMenu.Builder(toolbar, requireView() as ViewGroup)
        .preferredHorizontalPosition(SignalContextMenu.HorizontalPosition.END)
        .preferredVerticalPosition(SignalContextMenu.VerticalPosition.BELOW)
        .offsetX(16.dp)
        .offsetY((-4).dp)
        .show(
          listOf(
            ActionItem(
              iconRes = R.drawable.ic_open_24_tinted,
              title = getString(R.string.StoriesLandingItem__go_to_chat),
              action = {
                lifecycleDisposable += viewModel.getConversationData().flatMap { data ->
                  ConversationIntents.createBuilder(requireContext(), data.groupRecipientId, data.groupThreadId)
                }.subscribeBy {
                  startActivity(it.build())
                }
              }
            )
          )
        )
    }
    return super.onOptionsItemSelected(item)
  }

  override fun bindAdapter(adapter: MappingAdapter) {
    PrivateStoryItem.register(adapter)

    lifecycleDisposable.bindTo(viewLifecycleOwner)
    viewModel.state.observe(viewLifecycleOwner) { state ->
      if (state.removed) {
        findNavController().popBackStack()
        return@observe
      }

      setTitle(state.name)
      adapter.submitList(getConfiguration(state).toMappingModelList())
    }
  }

  private fun getConfiguration(state: GroupStorySettingsState): DSLConfiguration {
    return configure {
      sectionHeaderPref(R.string.GroupStorySettingsFragment__who_can_view_this_story)

      state.members.forEach {
        customPref(PrivateStoryItem.RecipientModel(it))
      }

      textPref(
        title = DSLSettingsText.from(
          getString(R.string.GroupStorySettingsFragment__members_of_the_group_s, state.name),
          DSLSettingsText.TextAppearanceModifier(R.style.Signal_Text_BodyMedium),
          DSLSettingsText.ColorModifier(ContextCompat.getColor(requireContext(), R.color.signal_colorOnSurfaceVariant))
        )
      )

      dividerPref()

      clickPref(
        title = DSLSettingsText.from(
          R.string.GroupStorySettingsFragment__remove_group_story,
          DSLSettingsText.ColorModifier(ContextCompat.getColor(requireContext(), R.color.signal_colorError))
        ),
        onClick = {
          StoryDialogs.removeGroupStory(
            requireContext(),
            viewModel.titleSnapshot
          ) {
            viewModel.doNotDisplayAsStory()
          }
        }
      )
    }
  }
}
