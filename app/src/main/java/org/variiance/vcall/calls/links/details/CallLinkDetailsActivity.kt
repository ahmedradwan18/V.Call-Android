/**
 * Copyright 2023 Signal Messenger, LLC
 * SPDX-License-Identifier: AGPL-3.0-only
 */

package org.variiance.vcall.calls.links.details

import android.content.Context
import android.content.Intent
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.NavHostFragment
import org.variiance.vcall.R
import org.variiance.vcall.components.FragmentWrapperActivity
import org.variiance.vcall.service.webrtc.links.CallLinkRoomId

class CallLinkDetailsActivity : FragmentWrapperActivity() {
  override fun getFragment(): Fragment = NavHostFragment.create(R.navigation.call_link_details, intent.extras!!.getBundle(BUNDLE))

  companion object {

    private const val BUNDLE = "bundle"

    fun createIntent(context: Context, callLinkRoomId: CallLinkRoomId): Intent {
      return Intent(context, CallLinkDetailsActivity::class.java)
        .putExtra(BUNDLE, CallLinkDetailsFragmentArgs.Builder(callLinkRoomId).build().toBundle())
    }
  }
}
