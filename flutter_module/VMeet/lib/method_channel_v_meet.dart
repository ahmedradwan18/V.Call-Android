import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'v_meet_platform_interface.dart';

const MethodChannel _channel = MethodChannel('v_meet');

const EventChannel _eventChannel = EventChannel('v_meet_events');

/// An implementation of [VMeetPlatform] that uses method channels.
class MethodChannelVMeet extends VMeetPlatform {
  final List<VMeetingListener> _listeners = <VMeetingListener>[];
  final Map<String, VMeetingListener> _perMeetingListeners = {};

  @override
  Future<VMeetingResponse> joinMeeting(
    VMeetingOptions options, {
    VMeetingListener? listener,
  }) async {
    // Attach a listener if it exists. The key is based on the serverURL + room
    if (listener != null) {
      String key;

      _listeners.add(listener);

      key = '${options.serverURL.trim()}/${options.room}';

      _perMeetingListeners.update(key, (oldListener) => listener,
          ifAbsent: () => listener);
      initialize();
    }
    if (options.userAvatarURL != null) {
      if (!options.userAvatarURL!.contains('https://')) {
        options.userAvatarURL = 'https://someimageurl.com/image.jpg';
      }
    }
    Map<String, dynamic> allOptions = {
      'room': options.room.trim(),
      'subject': options.subject,
      'serverURL': options.serverURL.trim(),
      'token': options.token,
      'audioMuted': options.audioMuted,
      'audioOnly': options.audioOnly,
      'videoMuted': options.videoMuted,
      'featureFlags': options.featureFlags,
      'userDisplayName': options.userDisplayName,
      'userEmail': options.userEmail,
      'iosAppBarRGBAColor': options.iosAppBarRGBAColor,
      'serverUrl': options.serverURL,
      'config': options.getconfig(),
      'userAvatarURL': options.userAvatarURL
    };

    return await _channel
        .invokeMethod<String>('joinMeeting', allOptions)
        .then((message) => VMeetingResponse(isSuccess: true, message: message))
        .catchError(
      (error) {
        return VMeetingResponse(
            isSuccess: true, message: error.toString(), error: error);
      },
    );
  }

  @override
  closeMeeting() {
    _channel.invokeMethod('closeMeeting');
  }

  @override
  addListener(VMeetingListener vMeetingListener) {
    _listeners.add(vMeetingListener);
    initialize();
  }

  @override
  removeListener(VMeetingListener vMeetingListener) {
    _listeners.remove(vMeetingListener);
  }

  @override
  removeAllListeners() {
    _listeners.clear();
  }

  @override
  void executeCommand(String command, List<String> args) {}

  @override
  Widget buildView(List<String> extraJS) {
    // return empty container for compatibily
    return Container(
      color: Colors.red,
    );
  }

  @override
  void initialize() {
    _eventChannel.receiveBroadcastStream().listen((dynamic message) {
      _broadcastToGlobalListeners(message);
    }, onError: (dynamic error) {
      debugPrint('V.Meet broadcast error: $error');
      for (var listener in _listeners) {
        if (listener.onError != null) listener.onError!(error);
      }
      _perMeetingListeners.forEach((key, listener) {
        if (listener.onError != null) listener.onError!(error);
      });
    });
  }

  /// Sends a broadcast to global listeners added using addListener
  void _broadcastToGlobalListeners(message) {
    for (var listener in _listeners) {
      switch (message['event']) {
        case 'onConferenceWillJoin':
          if (listener.onConferenceWillJoin != null) {
            listener.onConferenceWillJoin!(message);
          }
          break;
        case 'onConferenceJoined':
          if (listener.onConferenceJoined != null) {
            listener.onConferenceJoined!(message);
          }
          break;
        case 'onPictureInPictureTerminated':
          if (listener.onPictureInPictureTerminated != null) {
            listener.onPictureInPictureTerminated!(message);
          }
          break;
        case 'onPictureInPictureWillEnter':
          if (listener.onPictureInPictureWillEnter != null) {
            listener.onPictureInPictureWillEnter!(message);
          }
          break;
        case 'onScreenShareToggled':
          if (listener.onScreenShareToggled != null) {
            listener.onScreenShareToggled!(message);
          }
          break;
        case 'onConferenceTerminated':
          if (listener.onConferenceTerminated != null) {
            listener.onConferenceTerminated!(message);
          }
          break;
      }
    }
  }
}
