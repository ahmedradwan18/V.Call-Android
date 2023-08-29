import 'package:get/get.dart';

import '../../core/helpers/api_helper.dart';

import '../../core/helpers/auth_service.dart';
import '../../core/helpers/snackbar_helper.dart';
import '../../core/utils/dialog_helper.dart';
import '../../core/values/app_constants.dart';
import '../enums/snack_bar_type.dart';
import '../models/api_response.dart';
import '../models/meeting/meet_meeting_model.dart';

class MeetProvider extends GetConnect {
  //!==================================================
  Future<APIResponseModel> createMeetQuickMeeting(String title) async {
    try {
      //? 1] Prepare the body of the API Request
      final body = {
        'url': 'api/method/variiance.vconnct.api.v1.vconnct_engines'
            '.controllers.v2.meet_engine.create_quick_meeting_on_meet_engine',
        'data': {
          'user_id': AuthService().userID,
          'title': title,
          'platform': 'Mobile',
          'moderator': true,
          'user_name': AuthService().userName
        }
      };

      //? 2] call the API
      final apiResponse = await post(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //? 3] check the API's response, to avoid using garbage data
      //? and to redirect the flow to the error handlation part.
      //? If Room limit reached Show PopUp
      if (apiResponse.body['message']['error_description'] ==
          'Rooms limit reached') {
        await DialogHelper.goToUpCommingMeetings();
        return const APIResponseModel(
          succeeded: false,
          data: null,
        );
      } else {
        APIHelper.checkResponseForErrors(
          apiResponse,
        );
      }

      //? 4] ALL is good
      final meeting = MeetMeetingModel.fromJson(
        apiResponse.body['message']['data'],
      );

      return APIResponseModel(
        succeeded: true,
        data: meeting,
      );

      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'createMeetQuickMeeting',
        fileName: 'meet_provider',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> runMeetOnSchedule(String meetingID) async {
    try {
      //? 1] Prepare the body of the API Request
      final body = {
        'url':
            'api/method/variiance.vconnct.api.v1.vconnct_engines.controllers.v2.meet_engine.run_schedule_meeting',
        'data': {
          'engine_type': 'Meet',
          'platform_web_or_mobile': 'Mobile',
          'meeting_id': meetingID,
          'moderator': true,
          'username': AuthService().userName
        }
      };

      //? 2] call the API
      final apiResponse = await post(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //? 3] check the API's response, to avoid using garbage data
      //? and to redirect the flow to the error handlation part.
      //? If Room limit reached Show PopUp
      if (apiResponse.statusText == 'CONFLICT') {
        await DialogHelper.goToUpCommingMeetings();
        return const APIResponseModel(
          succeeded: false,
          data: null,
        );
      } else {
        APIHelper.checkResponseForErrors(
          apiResponse,
        );
      }

      //? 4] ALL is good
      final meeting = MeetMeetingModel.fromJson(
        apiResponse.body['data'],
      );

      return APIResponseModel(
        succeeded: true,
        data: meeting,
      );

      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'runMeetOnERP',
        fileName: 'meet_provider',
      );
    }
  }

  //!==================================================
  //!==================================================
  Future<APIResponseModel> joinRoomWithToken(
      {required String token, String? meetingTitle, String? userName}) async {
    try {
      //? 1] Prepare the body of the API Request
      final body = {
        'url': 'api/method/variiance.vconnct.api.v1.vconnct_engines'
            '.controllers.v2.meet_engine.join_vmeet_using_token',
        'data': {
          'token': token,
          'username': userName ?? AuthService().userFullName,
          'platform': 'Mobile',
          'meeting_title': meetingTitle ?? token
        }
      };

      //? 2] call the API
      final apiResponse = await post(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );
      //*=================================================
      if (apiResponse.body['status_code'] ==
          AppConstants.meetingAlreadyProgress) {
        SnackBarHelper.showSnackBar(
          message: 'another_meeting_is_already_in_progress_for_this_room'.tr,
          type: SnackBarType.error,
        );
      }
      if (apiResponse.body['status_code'] !=
          AppConstants.meetingAlreadyProgress) {
        APIHelper.checkResponseForErrors(apiResponse);
      }
      //*=================================================
      if (apiResponse.body['status_code'] ==
          AppConstants.meetingDifferentEngine) {
        SnackBarHelper.showSnackBar(
          message: 'another_meeting_is_running_on_different_engine'.tr,
          type: SnackBarType.error,
        );
      }
      if (apiResponse.body['status_code'] !=
          AppConstants.meetingDifferentEngine) {
        {
          APIHelper.checkResponseForErrors(apiResponse);
        }
      }
      //*=================================================
      var meeting = MeetMeetingModel.fromJson(apiResponse.body['data']);
      return APIResponseModel(
        succeeded: true,
        data: meeting,
      );
      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'runMeetOnERP',
        fileName: 'meet_provider',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> joinMeetWithMeetingId({
    required String meetingID,
    required String isModerator,
    String? userName,
  }) async {
    try {
      final name = userName ?? AuthService().userFullName;
      final moderator = isModerator == 'moderator' ? 1 : 0;
      //? 1] Prepare the body of the API Request
      final url =
          '?url=api/method/variiance.vconnct.api.v1.vconnct_engines.controllers'
          '.v2.meet_engine.join_meeting?meeting_id=$meetingID'
          '%26username=$name%26moderator=$moderator';

      //? 2] call the API
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl + url,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //? 3] check the API's response,
      APIHelper.checkResponseForErrors(
        apiResponse,
      );

      //? 4] ALL is good
      final meeting = MeetMeetingModel.fromJson(
        apiResponse.body['data'],
      );

      return APIResponseModel(
        succeeded: true,
        data: meeting,
      );

      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'joinMeetWithMeetingId',
        fileName: 'meet_provider',
      );
    }
  }

  //!==================================================
  //!===========================================================================
  //!===========================================================================
}
