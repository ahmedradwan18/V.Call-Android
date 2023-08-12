package org.variiance.vcall.components;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import android.text.SpannableStringBuilder;
import android.text.style.CharacterStyle;
import android.util.AttributeSet;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import org.signal.core.util.BreakIteratorCompat;
import org.signal.core.util.logging.Log;
import org.variiance.vcall.R;
import org.variiance.vcall.components.emoji.SimpleEmojiTextView;
import org.variiance.vcall.recipients.Recipient;
import org.variiance.vcall.util.ContextUtil;
import org.variiance.vcall.util.SpanUtil;
import org.variiance.vcall.util.ViewUtil;

import java.util.Iterator;
import java.util.Objects;

public class FromTextView extends SimpleEmojiTextView {

  private static final String TAG = Log.tag(FromTextView.class);

  public FromTextView(Context context) {
    super(context);
  }

  public FromTextView(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  public void setText(Recipient recipient) {
    setText(recipient, true);
  }

  public void setText(Recipient recipient, boolean read) {
    setText(recipient, read, null);
  }

  public void setText(Recipient recipient, boolean read, @Nullable String suffix) {
    setText(recipient, recipient.getDisplayNameOrUsername(getContext()), read, suffix);
  }

  public void setText(Recipient recipient, @Nullable CharSequence fromString, boolean read, @Nullable String suffix) {
    SpannableStringBuilder builder  = new SpannableStringBuilder();

    if (recipient.isSelf()) {
      builder.append(getContext().getString(R.string.note_to_self));
    } else {
      builder.append(fromString);
    }

    if (suffix != null) {
      builder.append(suffix);
    }

    if (recipient.showVerified()) {
      Drawable official = ContextUtil.requireDrawable(getContext(), R.drawable.ic_official_20);
      official.setBounds(0, 0, ViewUtil.dpToPx(20), ViewUtil.dpToPx(20));

      builder.append(" ")
             .append(SpanUtil.buildCenteredImageSpan(official));
    }

    setText(builder);

    if      (recipient.isBlocked()) setCompoundDrawablesRelativeWithIntrinsicBounds(R.drawable.ic_block_grey600_18dp, 0, 0, 0);
    else if (recipient.isMuted())   setCompoundDrawablesRelativeWithIntrinsicBounds(getMuted(), null, null, null);
    else                            setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, 0, 0);
  }

  private Drawable getMuted() {
    Drawable mutedDrawable = Objects.requireNonNull(ContextCompat.getDrawable(getContext(), R.drawable.ic_bell_disabled_16));

    mutedDrawable.setBounds(0, 0, ViewUtil.dpToPx(18), ViewUtil.dpToPx(18));
    mutedDrawable.setColorFilter(new PorterDuffColorFilter(ContextCompat.getColor(getContext(), R.color.signal_icon_tint_secondary), PorterDuff.Mode.SRC_IN));

    return mutedDrawable;
  }
}
