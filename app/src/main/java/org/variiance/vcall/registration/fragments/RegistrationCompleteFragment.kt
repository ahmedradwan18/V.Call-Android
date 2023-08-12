package org.variiance.vcall.registration.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.navigation.ActivityNavigator
import org.signal.core.util.logging.Log
import org.variiance.vcall.LoggingFragment
import org.variiance.vcall.MainActivity
import org.variiance.vcall.R
import org.variiance.vcall.dependencies.ApplicationDependencies
import org.variiance.vcall.jobs.MultiDeviceProfileContentUpdateJob
import org.variiance.vcall.jobs.MultiDeviceProfileKeyUpdateJob
import org.variiance.vcall.jobs.ProfileUploadJob
import org.variiance.vcall.keyvalue.SignalStore
import org.variiance.vcall.lock.v2.CreateSvrPinActivity
import org.variiance.vcall.pin.PinRestoreActivity
import org.variiance.vcall.profiles.AvatarHelper
import org.variiance.vcall.profiles.edit.EditProfileActivity
import org.variiance.vcall.recipients.Recipient
import org.variiance.vcall.registration.RegistrationUtil
import org.variiance.vcall.registration.viewmodel.RegistrationViewModel

/**
 * [RegistrationCompleteFragment] is not visible to the user, but functions as basically a redirect towards one of:
 * - [PIN Restore flow activity](org.variiance.vcall.pin.PinRestoreActivity)
 * - [Profile](org.variiance.vcall.profiles.edit.EditProfileActivity) / [PIN creation](org.variiance.vcall.lock.v2.CreateKbsPinActivity) flow activities (this class chains the necessary activities together as an intent)
 * - Exit registration flow and progress to conversation list
 */
class RegistrationCompleteFragment : LoggingFragment() {
  override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
    return inflater.inflate(R.layout.fragment_registration_blank, container, false)
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    val activity = requireActivity()
    val viewModel: RegistrationViewModel by viewModels(ownerProducer = { requireActivity() })

    if (SignalStore.misc().hasLinkedDevices) {
      SignalStore.misc().shouldShowLinkedDevicesReminder = viewModel.isReregister
    }

    if (SignalStore.storageService().needsAccountRestore()) {
      Log.i(TAG, "Performing pin restore.")
      activity.startActivity(Intent(activity, PinRestoreActivity::class.java))
    } else {
      val isProfileNameEmpty = Recipient.self().profileName.isEmpty
      val isAvatarEmpty = !AvatarHelper.hasAvatar(activity, Recipient.self().id)
      val needsProfile = isProfileNameEmpty || isAvatarEmpty
      val needsPin = !SignalStore.svr().hasPin() && !viewModel.isReregister

      Log.i(TAG, "Pin restore flow not required. Profile name: $isProfileNameEmpty | Profile avatar: $isAvatarEmpty | Needs PIN: $needsPin")

      if (!needsProfile && !needsPin) {
        ApplicationDependencies.getJobManager()
          .startChain(ProfileUploadJob())
          .then(listOf(MultiDeviceProfileKeyUpdateJob(), MultiDeviceProfileContentUpdateJob()))
          .enqueue()
        RegistrationUtil.maybeMarkRegistrationComplete()
      }

      var startIntent = MainActivity.clearTop(activity)

      if (needsPin) {
        startIntent = chainIntents(CreateSvrPinActivity.getIntentForPinCreate(activity), startIntent)
      }

      if (needsProfile) {
        startIntent = chainIntents(EditProfileActivity.getIntentForUserProfile(activity), startIntent)
      }

      activity.startActivity(startIntent)
    }

    activity.finish()
    ActivityNavigator.applyPopAnimationsToPendingTransition(activity)
  }

  private fun chainIntents(sourceIntent: Intent, nextIntent: Intent): Intent {
    sourceIntent.putExtra("next_intent", nextIntent)
    return sourceIntent
  }

  companion object {
    private val TAG = Log.tag(RegistrationCompleteFragment::class.java)
  }
}
