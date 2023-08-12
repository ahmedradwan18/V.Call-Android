package org.variiance.vcall.stories.my

import androidx.fragment.app.Fragment
import org.variiance.vcall.components.FragmentWrapperActivity

class MyStoriesActivity : FragmentWrapperActivity() {
  override fun getFragment(): Fragment {
    return MyStoriesFragment()
  }
}
