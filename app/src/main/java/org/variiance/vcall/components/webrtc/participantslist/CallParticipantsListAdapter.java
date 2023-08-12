package org.variiance.vcall.components.webrtc.participantslist;

import org.variiance.vcall.R;
import org.variiance.vcall.util.adapter.mapping.LayoutFactory;
import org.variiance.vcall.util.adapter.mapping.MappingAdapter;

public class CallParticipantsListAdapter extends MappingAdapter {

  CallParticipantsListAdapter() {
    registerFactory(CallParticipantsListHeader.class, new LayoutFactory<>(CallParticipantsListHeaderViewHolder::new, R.layout.call_participants_list_header));
    registerFactory(CallParticipantViewState.class, new LayoutFactory<>(CallParticipantViewHolder::new, R.layout.call_participants_list_item));
  }

}
