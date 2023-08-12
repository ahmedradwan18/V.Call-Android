package org.variiance.vcall.components.settings.conversation.preferences

import android.view.View
import org.variiance.vcall.R
import org.variiance.vcall.components.emoji.EmojiTextView
import org.variiance.vcall.components.settings.PreferenceModel
import org.variiance.vcall.groups.GroupId
import org.variiance.vcall.groups.v2.GroupDescriptionUtil
import org.variiance.vcall.util.LongClickMovementMethod
import org.variiance.vcall.util.adapter.mapping.LayoutFactory
import org.variiance.vcall.util.adapter.mapping.MappingAdapter
import org.variiance.vcall.util.adapter.mapping.MappingViewHolder

object GroupDescriptionPreference {

  fun register(adapter: MappingAdapter) {
    adapter.registerFactory(Model::class.java, LayoutFactory(::ViewHolder, R.layout.conversation_settings_group_description_preference))
  }

  class Model(
    private val groupId: GroupId,
    val groupDescription: String?,
    val descriptionShouldLinkify: Boolean,
    val canEditGroupAttributes: Boolean,
    val onEditGroupDescription: () -> Unit,
    val onViewGroupDescription: () -> Unit
  ) : PreferenceModel<Model>() {
    override fun areItemsTheSame(newItem: Model): Boolean {
      return groupId == newItem.groupId
    }

    override fun areContentsTheSame(newItem: Model): Boolean {
      return super.areContentsTheSame(newItem) &&
        groupDescription == newItem.groupDescription &&
        descriptionShouldLinkify == newItem.descriptionShouldLinkify &&
        canEditGroupAttributes == newItem.canEditGroupAttributes
    }
  }

  class ViewHolder(itemView: View) : MappingViewHolder<Model>(itemView) {

    private val groupDescriptionTextView: EmojiTextView = findViewById(R.id.manage_group_description)

    override fun bind(model: Model) {
      groupDescriptionTextView.movementMethod = LongClickMovementMethod.getInstance(context)

      if (model.groupDescription.isNullOrEmpty()) {
        if (model.canEditGroupAttributes) {
          groupDescriptionTextView.setOverflowText(null)
          groupDescriptionTextView.setText(R.string.ManageGroupActivity_add_group_description)
          groupDescriptionTextView.setOnClickListener { model.onEditGroupDescription() }
        }
      } else {
        groupDescriptionTextView.setOnClickListener(null)
        GroupDescriptionUtil.setText(
          context,
          groupDescriptionTextView,
          model.groupDescription,
          model.descriptionShouldLinkify
        ) {
          model.onViewGroupDescription()
        }
      }
    }
  }
}
