import 'dart:async';

import 'package:flutter/material.dart';

import 'v_meet_platform_interface.dart';

import 'room_name_constraint.dart';
import 'room_name_constraint_type.dart';

class VMeet {
  static bool _hasInitialized = false;

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      defaultRoomNameConstraints = {
    RoomNameConstraintType.minLength: RoomNameConstraint((value) {
      return value.trim().length >= 3;
    }, 'Minimum room length is 3'),
    RoomNameConstraintType.allowedChars: RoomNameConstraint((value) {
      return RegExp(r'^[a-zA-Z0-9-_]+$', caseSensitive: false, multiLine: false)
          .hasMatch(value);
    }, 'Only alphanumeric, dash, and underscore chars allowed'),
  };

  /// Joins a meeting based on the vMeetingOptions passed in.
  /// A vMeetingListener can be attached to this meeting that will automatically
  /// be removed when the meeting has ended
  static Future<VMeetingResponse> joinMeeting(VMeetingOptions options,
      {VMeetingListener? listener,
      Map<RoomNameConstraintType, RoomNameConstraint>?
          roomNameConstraints}) async {
    assert(options.room.trim().isNotEmpty, 'room is empty');

    // If no constraints given, take default ones
    // (To avoid using constraint, just give an empty Map)

    var roomNameConstraint = roomNameConstraints ?? defaultRoomNameConstraints;

    // Check each constraint, if it exist
    // (To avoid using constraint, just give an empty Map)
    if (roomNameConstraint.isNotEmpty) {
      for (RoomNameConstraint constraint in roomNameConstraint.values) {
        assert(
            constraint.checkConstraint(options.room), constraint.getMessage());
      }
    }

    return await VMeetPlatform.instance
        .joinMeeting(options, listener: listener);
  }

  /// Initializes the event channel. Call when listeners are added
  static _initialize() {
    if (!_hasInitialized) {
      VMeetPlatform.instance.initialize();
      _hasInitialized = true;
    }
  }

  static closeMeeting() => VMeetPlatform.instance.closeMeeting();

  /// Adds a vMeetingListener that will broadcast conference events
  static addListener(VMeetingListener vMeetingListener) {
    VMeetPlatform.instance.addListener(vMeetingListener);
    _initialize();
  }

  /// Removes the vMeetingListener specified
  static removeListener(VMeetingListener vMeetingListener) {
    VMeetPlatform.instance.removeListener(vMeetingListener);
  }

  /// Removes all vMeetingListeners
  static removeAllListeners() {
    VMeetPlatform.instance.removeAllListeners();
  }

  /// allow execute a command over a v live session (only for web)
  static executeCommand(String command, List<String> args) {
    VMeetPlatform.instance.executeCommand(command, args);
  }
}

/// Allow create a interface for web view and attach it as a child
/// optional param `extraJS` allows setup another external JS libraries
/// or Javascript embebed code
class VMeetConferencing extends StatelessWidget {
  final List<String>? extraJS;
  const VMeetConferencing({super.key, this.extraJS});

  @override
  Widget build(BuildContext context) {
    return VMeetPlatform.instance.buildView(extraJS!);
  }
}
