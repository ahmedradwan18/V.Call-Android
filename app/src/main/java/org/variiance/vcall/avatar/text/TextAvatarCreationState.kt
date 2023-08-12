package org.variiance.vcall.avatar.text

import org.variiance.vcall.avatar.Avatar
import org.variiance.vcall.avatar.AvatarColorItem
import org.variiance.vcall.avatar.Avatars

data class TextAvatarCreationState(
  val currentAvatar: Avatar.Text
) {
  fun colors(): List<AvatarColorItem> = Avatars.colors.map { AvatarColorItem(it, currentAvatar.color == it) }
}
