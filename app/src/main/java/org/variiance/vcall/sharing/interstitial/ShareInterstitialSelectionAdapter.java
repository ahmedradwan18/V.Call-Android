package org.variiance.vcall.sharing.interstitial;

import org.variiance.vcall.R;
import org.variiance.vcall.util.adapter.mapping.MappingAdapter;
import org.variiance.vcall.util.viewholders.RecipientViewHolder;

class ShareInterstitialSelectionAdapter extends MappingAdapter {
  ShareInterstitialSelectionAdapter() {
    registerFactory(ShareInterstitialMappingModel.class, RecipientViewHolder.createFactory(R.layout.share_contact_selection_item, null));
  }
}
