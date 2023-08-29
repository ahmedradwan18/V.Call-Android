import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'v_meet_options.dart';
import 'v_meet_response.dart';
import 'v_meeting_listener.dart';
import 'method_channel_v_meet.dart';

export 'v_meeting_listener.dart';
export 'v_meet_options.dart';
export 'v_meet_response.dart';

abstract class VMeetPlatform extends PlatformInterface {
  /// Constructs a VMeetPlatform.
  VMeetPlatform() : super(token: _token);

  static final Object _token = Object();

  static VMeetPlatform _instance = MethodChannelVMeet();

  /// The default instance of [VMeetPlatform] to use.
  ///
  /// Defaults to [MethodChannelVMeet].
  static VMeetPlatform get instance => _instance;

  static set instance(VMeetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Joins a meeting based on the VMeetingOptions passed in.
  /// A vMeetingListener can be attached to this meeting that
  /// will automatically be removed when the meeting has ended
  Future<VMeetingResponse> joinMeeting(VMeetingOptions options,
      {VMeetingListener? listener}) async {
    throw UnimplementedError('joinMeeting has not been implemented.');
  }

  closeMeeting() {
    throw UnimplementedError('joinMeeting has not been implemented.');
  }

  /// Adds a vMeetingListener that will broadcast conference events
  addListener(VMeetingListener vMeetingListener) {
    throw UnimplementedError('addListener has not been implemented.');
  }

  /// remove VListener
  removeListener(VMeetingListener vMeetingListener) {
    throw UnimplementedError('removeListener has not been implemented.');
  }

  /// Removes all vMeetingListeners
  removeAllListeners() {
    throw UnimplementedError('removeAllListeners has not been implemented.');
  }

  void initialize() {
    throw UnimplementedError('_initialize has not been implemented.');
  }

  /// execute command interface, use only in web
  void executeCommand(String command, List<String> args) {
    throw UnimplementedError('executeCommand has not been implemented.');
  }

  /// buildView
  /// Method added to support Web plugin, the main purpose is return a <div>
  /// to contain the conferencing screen when start
  /// additionally extra JS can be added usin `extraJS` argument
  /// for mobile is not need because the conferecing view get all device screen
  Widget buildView(List<String> extraJS) {
    throw UnimplementedError('_buildView has not been implemented.');
  }
}
