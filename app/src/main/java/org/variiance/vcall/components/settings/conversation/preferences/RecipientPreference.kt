package org.variiance.vcall.components.settings.conversation.preferences

import android.view.View
import android.widget.TextView
import org.variiance.vcall.R
import org.variiance.vcall.badges.BadgeImageView
import org.variiance.vcall.components.AvatarImageView
import org.variiance.vcall.components.settings.PreferenceModel
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.util.adapter.mapping.LayoutFactory
import org.variiance.vcall.util.adapter.mapping.MappingAdapter
import org.variiance.vcall.util.adapter.mapping.MappingViewHolder
import org.variiance.vcall.util.visible

/**
 * Renders a Recipient as a row item with an icon, avatar, status, and admin state
 */
object RecipientPreference {

  fun register(adapter: MappingAdapter) {
    adapter.registerFactory(Model::class.java, LayoutFactory(::ViewHolder, R.layout.group_recipient_list_item))
  }

  class Model(
    val recipient: Recipient,
    val isAdmin: Boolean = false,
    val onClick: (() -> Unit)? = null
  ) : PreferenceModel<Model>() {
    override fun areItemsTheSame(newItem: Model): Boolean {
      return recipient.id == newItem.recipient.id
    }

    override fun areContentsTheSame(newItem: Model): Boolean {
      return super.areContentsTheSame(newItem) &&
        recipient.hasSameContent(newItem.recipient) &&
        isAdmin == newItem.isAdmin
    }
  }

  class ViewHolder(itemView: View) : MappingViewHolder<Model>(itemView) {
    private val avatar: AvatarImageView = itemView.findViewById(R.id.recipient_avatar)
    private val name: TextView = itemView.findViewById(R.id.recipient_name)
    private val about: TextView? = itemView.findViewById(R.id.recipient_about)
    private val admin: View? = itemView.findViewById(R.id.admin)
    private val badge: BadgeImageView = itemView.findViewById(R.id.recipient_badge)

    override fun bind(model: Model) {
      if (model.onClick != null) {
        itemView.setOnClickListener { model.onClick.invoke() }
      } else {
        itemView.setOnClickListener(null)
      }

      avatar.setRecipient(model.recipient)
      badge.setBadgeFromRecipient(model.recipient)
      name.text = if (model.recipient.isSelf) {
        context.getString(R.string.Recipient_you)
      } else {
        model.recipient.getDisplayName(context)
      }

      val aboutText = model.recipient.combinedAboutAndEmoji
      if (aboutText.isNullOrEmpty()) {
        about?.visibility = View.GONE
      } else {
        about?.text = model.recipient.combinedAboutAndEmoji
        about?.visibility = View.VISIBLE
      }

      admin?.visible = model.isAdmin
    }
  }
}
