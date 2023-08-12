package org.variiance.vcall.avatar.vector

import org.variiance.vcall.avatar.Avatar
import org.variiance.vcall.avatar.AvatarColorItem
import org.variiance.vcall.avatar.Avatars

data class VectorAvatarCreationState(
  val currentAvatar: Avatar.Vector
) {
  fun colors(): List<AvatarColorItem> = Avatars.colors.map { AvatarColorItem(it, currentAvatar.color == it) }
}
