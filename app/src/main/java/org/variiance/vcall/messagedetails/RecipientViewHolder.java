package org.variiance.vcall.messagedetails;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import org.variiance.vcall.R;
import org.variiance.vcall.badges.BadgeImageView;
import org.variiance.vcall.components.AvatarImageView;
import org.variiance.vcall.components.FromTextView;
import org.variiance.vcall.util.DateUtils;
import org.variiance.vcall.util.TextSecurePreferences;

import java.util.Locale;

final class RecipientViewHolder extends RecyclerView.ViewHolder {
  private final AvatarImageView                 avatar;
  private final FromTextView                    fromView;
  private final TextView                        timestamp;
  private final TextView                        error;
  private final View                            conflictButton;
  private final View                            unidentifiedDeliveryIcon;
  private final BadgeImageView                  badge;
  private       MessageDetailsAdapter.Callbacks callbacks;

  RecipientViewHolder(@NonNull View itemView, @NonNull MessageDetailsAdapter.Callbacks callbacks) {
    super(itemView);

    this.callbacks = callbacks;

    fromView                 = itemView.findViewById(R.id.message_details_recipient_name);
    avatar                   = itemView.findViewById(R.id.message_details_recipient_avatar);
    timestamp                = itemView.findViewById(R.id.message_details_recipient_timestamp);
    error                    = itemView.findViewById(R.id.message_details_recipient_error_description);
    conflictButton           = itemView.findViewById(R.id.message_details_recipient_conflict_button);
    unidentifiedDeliveryIcon = itemView.findViewById(R.id.message_details_recipient_ud_indicator);
    badge                    = itemView.findViewById(R.id.message_details_recipient_badge);
  }

  void bind(RecipientDeliveryStatus data) {
    unidentifiedDeliveryIcon.setVisibility(TextSecurePreferences.isShowUnidentifiedDeliveryIndicatorsEnabled(itemView.getContext()) && data.isUnidentified() ? View.VISIBLE : View.GONE);
    fromView.setText(data.getRecipient());
    avatar.setRecipient(data.getRecipient());
    badge.setBadgeFromRecipient(data.getRecipient());

    if (data.getKeyMismatchFailure() != null) {
      timestamp.setVisibility(View.GONE);
      error.setVisibility(View.VISIBLE);
      conflictButton.setVisibility(View.VISIBLE);
      error.setText(itemView.getContext().getString(R.string.message_details_recipient__new_safety_number));
      conflictButton.setOnClickListener(unused -> callbacks.onErrorClicked(data.getMessageRecord()));
    } else if ((data.getNetworkFailure() != null && !data.getMessageRecord().isPending()) || (!data.getMessageRecord().getToRecipient().isPushGroup() && data.getMessageRecord().isFailed())) {
      timestamp.setVisibility(View.GONE);
      error.setVisibility(View.VISIBLE);
      conflictButton.setVisibility(View.GONE);
      error.setText(itemView.getContext().getString(R.string.message_details_recipient__failed_to_send));
    } else {
      timestamp.setVisibility(View.VISIBLE);
      error.setVisibility(View.GONE);
      conflictButton.setVisibility(View.GONE);

      if (data.getTimestamp() > 0) {
        Locale dateLocale = Locale.getDefault();
        timestamp.setText(DateUtils.getTimeString(itemView.getContext(), dateLocale, data.getTimestamp()));
      } else {
        timestamp.setText("");
      }
    }
  }
}
