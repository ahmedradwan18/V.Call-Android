import 'package:get/get_connect.dart';
import '../../core/helpers/api_helper.dart';
import '../../core/helpers/auth_service.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/values/app_constants.dart';
import '../enums/meeting_status.dart';
import '../enums/meeting_type.dart';
import '../models/api_response.dart';
import '../models/creation/meeting_template.dart';
import '../models/meeting/classroom_meeting_model.dart';
import '../models/room/room_settings_model.dart';

class CreationProvider extends GetConnect {
  //!================================ Methods ==================================
  ///! AT [ERP] level
  Future<APIResponseModel> createMeetingAtERP(
      {required MeetingTemplate meetingTemplate,
      required MeetingType engineType,
      required List<Map<String, dynamic>> settings}) async {
    try {
      // 1] parameters
      var body = {
        'url': 'api/method/vconnct.v2.meeting.create',
        'data': {
          'engine_type': engineType.label,
          'student_id': AuthService().userID,
          'title': meetingTemplate.title.trim(),
          'room_id': meetingTemplate.roomID,
          'password': meetingTemplate.password.trim(),
          'meeting_date': meetingTemplate.date,
          // if I sent the minute i'm at .. it'll cause an error at the API
          // so i'll add [1] Minute to the time of the meeting
          'meeting_time': DateTimeUtils.adjustMeetingTime(meetingTemplate.time),
          // send the status as [Not Started] in both cases,
          'meeting_status': MeetingStatus.upcoming.statusString,
          'meeting_settings': settings,

          'platform_web_or_mobile': 'Mobile',
        }
      };

      // 2] call
      final apiResponse = await post(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      );

      // 3] check response
      APIHelper.checkResponseForErrors(apiResponse);

      // 4] handle success
      // add :
      // 1] the id of the [Meeting]
      // 2] the link of the [Meeting] to the [MeetingTemplate] as i'll use it
      // to create the meeting from it
      meetingTemplate.id = apiResponse.body['data']['name'];
      meetingTemplate.link = apiResponse.body['data']['meeting_url'];
      final meeting = ClassroomMeetingModel.fromTemplate(
        meetingTemplate,
        settingList: meetingTemplate.settingList,
      );

      // assign the meeting's settings, to be used in [Run Meeting]
      // updated seperatly to allow updating from elsewhere, if I sent my
      // [meeting_settings] in the [Json], it'll be set, but all other meetings
      // will have [NULL] and won't be able re re-assign them

      return APIResponseModel(
        succeeded: apiResponse.body['data'] != [],
        data: meeting,
      );
    } catch (e) {
      //5] handle failures
      return APIHelper.handleFailure(
        error: e,
        methodName: 'createMeeting',
        fileName: 'meeting_Provider',
      );
    }
  }

  //!==================================================
  Future<ClassroomMeetingModel?> editMeeting({
    required MeetingTemplate meetingTemplate,
    required List<Map<String, dynamic>> settings,
    required MeetingType engineType,
  }) async {
    try {
      // 1] parms
      final body = {
        'url': 'api/method/vconnct.v2.meeting.edit',
        'data': {
          // use the meetingTemplate as it holds the latest values
          'meeting_id': meetingTemplate.id,
          'title': meetingTemplate.title.trim(),
          'room_id': meetingTemplate.roomID,
          'password': meetingTemplate.password.trim(),
          // was instructed to keep it always set like this
          'meeting_status': MeetingStatus.upcoming.statusString,
          'meeting_date': meetingTemplate.date,
          'meeting_time': meetingTemplate.time,
          'meeting_settings': settings,
          'engine_type': engineType.label,
        }
      };

      // 2] call
      final apiResponse = await put(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      );

      // 3] check for errors
      APIHelper.checkResponseForErrors(apiResponse);

      // 4] handle success, edit [meeting] locally to refelct the changes
      return ClassroomMeetingModel.fromTemplate(meetingTemplate);
    } catch (e) {
      // 5] handle failure
      APIHelper.handleFailure(
        error: e,
        methodName: 'editMeeting',
        fileName: 'creation_provider',
      );
      return null;
    }
  }

  //!==================================================
  Future<RoomSettingsModel?> getMeetingSettings(
      String meetingDataBaseID) async {
    try {
      // 1] parms
      final query = {
        'url': 'api/method/vconnct.v2.meeting.show'
            '?meeting_id=$meetingDataBaseID',
      };

      // 2] call
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      );

      // 3] check for errors
      APIHelper.checkResponseForErrors(apiResponse);

      // 4] handle success
      return RoomSettingsModel.meetingSettingfromJson(apiResponse.body['data']);
    } catch (e) {
      // 5] handle failure
      APIHelper.handleFailure(
        error: e,
        methodName: 'getMeetingSettings',
        fileName: 'meeting_provider',
      );
      return null;
    }
  }

  //!==================================================
  Future<List<String>?> getMeetingInvitedContactList(
    String meetingID,
  ) async {
    try {
      // 1] parms
      final query = {
        'url': 'api/method/vconnct.v1.meeting'
            '.get_meeting_invitations'
            '?meeting_id=$meetingID'
      };

      // 2] call
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      );

      // 3] check for errors
      APIHelper.checkResponseForErrors(apiResponse);

      // 4] handle success
      final invitedContactList = apiResponse.body['data']
          .map<String>((map) => map['student_id'].toString())
          .toList();

      return invitedContactList;
    } catch (e) {
      // 5] handle failure
      APIHelper.handleFailure(
        error: e,
        methodName: 'getMeetingInvitedContactList',
        fileName: 'creation_provider',
      );
      return null;
    }
  }
  //!===========================================================================
  //!===========================================================================
}
