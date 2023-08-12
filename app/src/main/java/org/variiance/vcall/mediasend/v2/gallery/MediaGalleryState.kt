package org.variiance.vcall.mediasend.v2.gallery

import org.variiance.vcall.util.adapter.mapping.MappingModel

data class MediaGalleryState(
  val bucketId: String?,
  val bucketTitle: String?,
  val items: List<MappingModel<*>> = listOf()
)
