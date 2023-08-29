package com.variiance.v_meet

import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import com.variiance.v_meet.VMeetPlugin.Companion.V_MEETING_CLOSE
import com.variiance.v_meet.VMeetPlugin.Companion.VMeet_PLUGIN_TAG
import org.v.meet.sdk.VMeetActivity
import org.v.meet.sdk.VMeetConferenceOptions

/**
 * Activity extending VMeetActivity in order to override the conference events
 */
class VMeetPluginActivity : VMeetActivity() {
    companion object {
        @JvmStatic
        fun launchActivity(context: Context?,
                           options: VMeetConferenceOptions) {
            var intent = Intent(context, VMeetPluginActivity::class.java).apply {
                action = "org.v.meet.CONFERENCE"
                putExtra("VMeetConferenceOptions", options)
            }
            context?.startActivity(intent)
        }
    }

    var onStopCalled: Boolean = false;

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration?) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)

        if (isInPictureInPictureMode){
            VMeetEventStreamHandler.instance.onPictureInPictureWillEnter()
        }
        else {
            VMeetEventStreamHandler.instance.onPictureInPictureTerminated()
        }

        if (isInPictureInPictureMode == false && onStopCalled) {
            // Picture-in-Picture mode has been closed, we can (should !) end the call
            // getVMeetView().leave()
        }
    }

    private val myReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent?.action) {
                V_MEETING_CLOSE -> finish()
            }
        }
    }

    override fun onStop() {
        super.onStop()
        onStopCalled = true;
        unregisterReceiver(myReceiver)
    }

    override fun onResume() {
        super.onResume()
        onStopCalled = false
        registerReceiver(myReceiver, IntentFilter(V_MEETING_CLOSE))
    }

    override fun onConferenceWillJoin(data: HashMap<String, Any>) {
        Log.d(VMeet_PLUGIN_TAG, String.format("VMeetPluginActivity.onConferenceWillJoin: %s", data))
        VMeetEventStreamHandler.instance.onConferenceWillJoin(data)
        super.onConferenceWillJoin(data)
    }
    
    
    override fun onScreenShareToggled(data: HashMap<String, Any>) {
        Log.d(VMeet_PLUGIN_TAG, String.format("VMeetPluginActivity.onScreenShareToggled: %s", data))
        VMeetEventStreamHandler.instance.onScreenShareToggled(data)
        super.onScreenShareToggled(data)
    }

    override fun onConferenceJoined(data: HashMap<String, Any>) {
        Log.d(VMeet_PLUGIN_TAG, String.format("VMeetPluginActivity.onConferenceJoined: %s", data))
        VMeetEventStreamHandler.instance.onConferenceJoined(data)
        super.onConferenceJoined(data)
    }

    override fun onConferenceTerminated(data: HashMap<String, Any>) {

        Log.d(VMeet_PLUGIN_TAG, String.format("VMeetPluginActivity.onConferenceTerminated: %s", data))
        VMeetEventStreamHandler.instance.onConferenceTerminated(data)
        super.onConferenceTerminated(data)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        turnScreenOnAndKeyguardOff();
    }

    override fun onDestroy() {
        super.onDestroy()
        turnScreenOffAndKeyguardOn();
    }

    private fun turnScreenOnAndKeyguardOff() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            // For newer than Android Oreo: call setShowWhenLocked, setTurnScreenOn
            setShowWhenLocked(true)
            setTurnScreenOn(true)

            // If you want to display the keyguard to prompt the user to unlock the phone:
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager?.requestDismissKeyguard(this, null)
        } else {
            // For older versions, do it as you did before.
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                    or WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                    or WindowManager.LayoutParams.FLAG_FULLSCREEN
                    or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON)
        }
    }

    private fun turnScreenOffAndKeyguardOn() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            window.clearFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                            or WindowManager.LayoutParams.FLAG_FULLSCREEN
                            or WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                            or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                            or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                            or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
            )
        }
    }
}
