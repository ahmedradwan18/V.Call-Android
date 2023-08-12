package org.variiance.vcall.stories.viewer.page

import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.View
import androidx.appcompat.widget.AppCompatImageView
import androidx.fragment.app.Fragment
import org.variiance.vcall.R
import org.variiance.vcall.conversation.colors.AvatarColor

class TestFragment : Fragment(R.layout.test_fragment) {
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    (view as AppCompatImageView).setImageDrawable(ColorDrawable(AvatarColor.random().colorInt()))
  }
}
