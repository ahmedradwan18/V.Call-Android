import 'dart:io';

// import 'package:VMeet/v_meet.dart';
// import 'package:VMeet/v_meet_options.dart';

// import 'package:VMeet/v_meet.dart';
// import 'package:VMeet/v_meet_options.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import 'package:VMeet/v_meet.dart';
import 'package:VMeet/v_meet_platform_interface.dart';

import '../../data/models/meeting/meet_meeting_model.dart';
import '../utils/logging_service.dart';

class MeetHelper {
//!=============================== Constructor ===============================
  static final MeetHelper _singleton = MeetHelper._internal();
  factory MeetHelper() {
    return _singleton;
  }
  MeetHelper._internal();
//!=============================================================================

  static Future<bool> runMeet({required MeetMeetingModel meetingData}) async {
    try {
      LoggingService.information(' TESTTTTTTTT ');

      var options = VMeetingOptions(
        room: meetingData.meetingDataBaseID,
        serverURL: meetingData.domain,
        // subject = meetingData.meetingTitle
        // userDisplayName = meetingData.userName
        // userEmail = meetingData.userEmail
        // userAvatarURL = AuthService().userImage

        // featureFlags = meetingData.settingList!;
      )..token = meetingData.token;

      print('object');
      await VMeet.joinMeeting(options);
      print('object5');

      return true;
    } catch (e) {
      LoggingService.error(
        'Error at Method: runMeet -- meet_helper.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }
//!=============================================================================
//!=============================================================================
}
