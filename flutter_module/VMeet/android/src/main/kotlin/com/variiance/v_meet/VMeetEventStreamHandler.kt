package com.variiance.v_meet

import android.util.Log
import com.variiance.v_meet.VMeetPlugin.Companion.VMeet_PLUGIN_TAG
import io.flutter.plugin.common.EventChannel
import java.io.Serializable

/**
 * StreamHandler to listen to conference events and broadcast it back to Flutter
 */
class VMeetEventStreamHandler private constructor(): EventChannel.StreamHandler, Serializable {
    companion object {
        val instance = VMeetEventStreamHandler()
    }

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onListen")
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onCancel")
        eventSink = null
    }

    fun onConferenceWillJoin(data: MutableMap<String, Any>?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onConferenceWillJoin")
        data?.put("event", "onConferenceWillJoin")
        eventSink?.success(data)
    }

    fun onScreenShareToggled(data: MutableMap<String, Any>?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onScreenShareToggled")
        data?.put("event", "onScreenShareToggled")
        eventSink?.success(data)
    }

    fun onConferenceJoined(data: MutableMap<String, Any>?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onConferenceJoined")
        data?.put("event", "onConferenceJoined")
        eventSink?.success(data)
    }

    fun onConferenceTerminated(data: MutableMap<String, Any>?) {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onConferenceTerminated")
        data?.put("event", "onConferenceTerminated")
        eventSink?.success(data)
    }

    fun onPictureInPictureWillEnter() {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onPictureInPictureWillEnter")
        var data : HashMap<String, String>
                = HashMap<String, String> ()
        data?.put("event", "onPictureInPictureWillEnter")
        eventSink?.success(data)
    }

    fun onPictureInPictureTerminated() {
        Log.d(VMeet_PLUGIN_TAG, "VMeetEventStreamHandler.onPictureInPictureTerminated")
        var data : HashMap<String, String>
                = HashMap<String, String> ()
        data?.put("event", "onPictureInPictureTerminated")
        eventSink?.success(data)
    }

}