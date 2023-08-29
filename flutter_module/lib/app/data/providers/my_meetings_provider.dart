import 'package:get/get_connect.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../core/helpers/api_helper.dart';
import '../../core/helpers/auth_service.dart';
import '../../core/values/app_constants.dart';
import '../enums/meeting_status.dart';
import '../models/api_response.dart';
import '../models/meeting/classroom_meeting_model.dart';
import '../models/meeting/meet_meeting_model.dart';
import '../models/meeting/meeting_filter_model.dart';

class MyMeetingsProvider extends GetConnect {
  //!=========================== [MyMeetings] Methods ==========================
  /// API call to get [Upcoming Meeting] and [Log Meeting] based on passed
  /// parameter [MeetingStatus]
  Future<List<dynamic>?> getMeetings(
    MeetingStatus status, {
    int paginationIndex = 1,
  }) async {
    try {
      //1] Initialize the parameters
      final query = {
        'url': 'api/method/vconnct.v1.meeting.index'
            '?student_id=${AuthService().userID}'
            '&status=${status.statusString}'
      };
      //2] call the api..
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //3] check the reponse for errors
      APIHelper.checkResponseForErrors(apiResponse);

      //4] handle success, All is Good
      return _decodeJsonList(apiResponse.body['data']);
    } catch (e) {
      //5] catch any errors
      APIHelper.handleFailure(
        error: e,
        methodName: 'getMeetings',
        fileName: 'my_meeting_provider',
      );
    }
    return null;
  }

  //!==================================================
  //! HARD DELETE
  Future<APIResponseModel> deleteMeeting(String databaseID) async {
    try {
      final query = {
        'url': 'api/method/vconnct.v1.meeting.delete'
            '?obj_id=$databaseID',
      };

      final apiResponse = await delete(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      );

      APIHelper.checkResponseForErrors(apiResponse);

      return APIResponseModel(
        succeeded: true,
        data: 'meeting_deleted_success'.tr,
      );
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'removeMeeting',
        fileName: 'my_meeting_provider.dart',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> joinMeetingAsModerator(
    String meetingID,
  ) async {
    try {
      final url = '${AppConstants.environment.vlcLayerUrl}/vlc'
          '/join_moderator_v2/$meetingID';

      final body = {
        'user_name': AuthService().userName,
        'student_id': AuthService().userID,
      };

      final apiResponse = await post(
        url,
        body,
        headers: APIHelper.apiHeaders,
      );

      APIHelper.checkResponseForErrors(apiResponse);

      // handle success.
      // return the meetingLink
      return APIResponseModel(
        succeeded: true,
        data: apiResponse.body['data'],
      );
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'joinMeeting',
        fileName: 'Meeting_Provider',
      );
    }
  }

  //*==================================================
  Future<List<dynamic>?> searchWithFilter({
    required MeetingFilterModel filter,
    String query = '',
    int paginationIndex = 1,
    MeetingStatus meetingStatus = MeetingStatus.started,
  }) async {
    try {
      //1] Initialize the parameters
      final apiQuery = {
        'url': 'api/method/vconnct.v1.meeting.index'
            '?student_id=${AuthService().userID}'
            '&status=${meetingStatus.statusString}'
            '&q=$query'
            '&from_date=${filter.startDate}'
            '&to_date=${filter.endDate}'
            '&rooms=${filter.roomList.join(',')}'
            '&recorded=${filter.showRecorded}'
            '&not_recorded=${filter.showNotRecorded}'
            '&page=$paginationIndex'
      };

      //2] call the api..
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: apiQuery,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //3] check the reponse for errors
      APIHelper.checkResponseForErrors(apiResponse);

      //4] handle success, All is Good

      return _decodeJsonList(apiResponse.body['data']);
    } catch (e) {
      //5] catch any errors
      APIHelper.handleFailure(
        error: e,
        methodName: 'searchWithFilter',
        fileName: 'my_meeting_provider',
      );
    }
    return null;
  }

  //*==================================================
  List<dynamic> _decodeJsonList(dynamic json) {
    var list = List<dynamic>.from(
      json.map(
        (jsonMeeting) {
          if (jsonMeeting['engine_type'] == 'Meet') {
            return MeetMeetingModel.fromJsonInUpComing(jsonMeeting);
          }
        },
      ),
    );

    return list.whereType<MeetMeetingModel>().toList();
  }

  //*==================================================
  Future<APIResponseModel> endClassroomMeeting(dynamic meetingID) async {
    try {
      final url = '${AppConstants.environment.vlcLayerUrl}/vlc'
          '/end_meeting/$meetingID';

      final apiResponse = await get(
        url,
        headers: APIHelper.apiHeaders,
      );

      APIHelper.checkResponseForErrors(apiResponse);

      // handle success.
      // return the meetingLink
      return APIResponseModel(
        succeeded: true,
        data: apiResponse.body['message'],
      );
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'endClassroomMeeting',
        fileName: 'my_meeting_provider',
      );
    }
  }

  //*==================================================
  Future<APIResponseModel> endMeetMeeting(
      {required String meetingID, required String domain}) async {
    try {
      final url = '$domain/api/end_meeting?room=$meetingID';

      final apiResponse = await get(
        url,
        headers: APIHelper.apiHeaders,
      );

      APIHelper.checkResponseForErrors(apiResponse);

      // handle success.
      // return the meetingLink
      return APIResponseModel(
        succeeded: true,
        data: apiResponse.body['message'],
      );
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'endMeetMeeting',
        fileName: 'my_meeting_provider',
      );
    }
  }

  //!===========================================================================
  //!===========================================================================
}
