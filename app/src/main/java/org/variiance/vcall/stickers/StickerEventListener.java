package org.variiance.vcall.stickers;

import androidx.annotation.NonNull;

import org.variiance.vcall.database.model.StickerRecord;

public interface StickerEventListener {
  void onStickerSelected(@NonNull StickerRecord sticker);

  void onStickerManagementClicked();
}
