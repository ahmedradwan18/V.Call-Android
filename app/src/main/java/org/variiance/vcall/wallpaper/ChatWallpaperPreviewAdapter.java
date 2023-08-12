package org.variiance.vcall.wallpaper;

import org.variiance.vcall.R;
import org.variiance.vcall.util.adapter.mapping.MappingAdapter;

class ChatWallpaperPreviewAdapter extends MappingAdapter {
  ChatWallpaperPreviewAdapter() {
    registerFactory(ChatWallpaperSelectionMappingModel.class, ChatWallpaperViewHolder.createFactory(R.layout.chat_wallpaper_preview_fragment_adapter_item, null, null));
  }
}
