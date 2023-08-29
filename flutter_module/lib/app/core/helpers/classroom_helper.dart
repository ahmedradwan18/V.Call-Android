import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import '../../data/models/meeting/classroom_meeting_model.dart';
import '../../data/models/room/room_settings_model.dart';
import '../../data/models/vlc_view_arguments.dart';
import '../../data/providers/creation_provider.dart';
import '../../data/providers/meeting_provider.dart';
import '../../routes/app_pages.dart';
import '../utils/logging_service.dart';
import 'api_helper.dart';
import 'auth_service.dart';
import 'helpers.dart';

class ClassroomHelper {
  //!================================ Parameters ===============================

  //!===========================================================================
  //!=============================== Constructor ===============================
  //!===========================================================================
  static const ClassroomHelper _singleton = ClassroomHelper._internal();
  factory ClassroomHelper() {
    return _singleton;
  }
  const ClassroomHelper._internal();
  //!===========================================================================
  //!================================= Methods =================================
  //!===========================================================================

  //!==================================================
  static Future<bool> runMeeting(ClassroomMeetingModel meeting) async {
    try {
      // Create Meeting at VLC, And Run it
      RoomSettingsModel? settingList;
      if (meeting.settingList!.meetingGroupsSettings.isEmpty) {
        settingList = await getMeetingSettings(meeting.meetingDataBaseID);
      }
      final apiResponse =
          await MeetingProvider().runMeeting(meeting, settingList);
      if (!(apiResponse.succeeded)) {
        APIHelper.showAPIResponseSnackbar(apiResponse);
        return false;
      }

      final eventValues = {
        'user_ID': AuthService().userID,
        'is_pro_user': (!AuthService().isUserFree).toString(),
        'meeting_id': meeting.meetingDataBaseID,
        'meeting_title': meeting.meetingTitle,
        'meeting_link': meeting.link,
        'meeting_time': meeting.meetingTime,
        'meeting_date': meeting.meetingDate,
      };

      // Logg an Event
      // AppsFlyerService.appsFlyer.logEvent('meeting_creation', eventValues);
      // await AnalyticsService.instance.logEvent(
      //   name: 'meeting_creation',
      //   parameters: eventValues,
      // );

      // Open the Meeting
      await navigateToMeeting(
        VlcViewArugumets(
          url: apiResponse.data,
          meeting: meeting,
        ),
      );
      return true;
    } catch (e) {
      LoggingService.error(
        'Error at Method:runMeeting -- classroom_helper.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  /// Opens the [VLC] View with the meeting.
  static Future<void> navigateToMeeting(VlcViewArugumets arugumets) async {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // Allow all orientations
    await Helpers.setAppOrientation();
    // Navigate
    await Get.toNamed(
      Routes.vlc,
      arguments: arugumets,
    );
    // Restrict Orientations
    await Helpers.setAppOrientation(Orientation.portrait);
    Helpers.changeSystemUIColor();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  //!==================================================

  /// bool to indicate whether or not the method was a success.
  /// will add the settingList to [ClassroomMeetingModel] to give the functionality
  /// of caching

  static Future<RoomSettingsModel?> getMeetingSettings(
    String meetingID,
  ) async {
    // Log
    LoggingService.information(
      'User Fetched Setting for meeting with'
      ' ID:[$meetingID]',
    );

    return CreationProvider().getMeetingSettings(
      meetingID,
    );
  }

  //!===========================================================================
  //!===========================================================================
}
