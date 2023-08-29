import 'package:get/get.dart';
import '../../core/helpers/api_helper.dart';
import '../../core/helpers/auth_service.dart';
import '../../core/utils/dialog_helper.dart';
import '../../core/values/app_constants.dart';
import '../models/api_response.dart';
import '../models/meeting/before_join_model.dart';
import '../models/meeting/classroom_meeting_model.dart';
import '../models/meeting/general_settings_model.dart';
import '../models/room/room_settings_model.dart';

class MeetingProvider extends GetConnect {
  //!===========================================================================
  //!========================= Controller Methods ==============================
  //!===========================================================================
  // Is used throughout the Application.
  Future<APIResponseModel> runMeeting(
      ClassroomMeetingModel meeting, RoomSettingsModel? settingList) async {
    try {
      var subscriptionSettings = {
        'group_title': 'Subscription',
        'group_settings': [
          {
            'setting_title': 'meeting max Participants',
            'setting_key': 'maxParticipants',
            'setting_value':
                // AuthService()
                //         .user
                //         ?.subscriptionUsage
                //         ?.participantCapacity
                //         ?.intPackageLimit ??
                ''
          },
          {
            'setting_title': 'meeting duration',
            'setting_key': 'duration',
            'setting_value':
                // AuthService()
                //         .user
                //         ?.subscriptionUsage
                //         ?.meetingDuration
                //         ?.intPackageLimit ??
                '',
          }
        ]
      };
      var roomSettings = settingList ?? meeting.settingList;
      var settings =
          roomSettings?.meetingGroupsSettings.map((e) => e.toJson()).toList();

      settings?.insert(0, subscriptionSettings);
      // 1] parms
      final url = '${AppConstants.environment.vlcLayerUrl}/vlc'
          '/create_meeting_v2/${meeting.meetingDataBaseID}';
      final body = {
        'meeting_name': meeting.meetingTitle,
        'password': meeting.meetingPassword,
        'user_name': AuthService().userName,
        'end_meeting_redirect_url':
            AppConstants.environment.exitMeetingRedirectUrl,
        'welcome_message': '${'Come_join_me_at_my_V.Connct_meeting'.tr} <br/>'
            '${'meeting_name'.tr}: ${meeting.meetingTitle} <br/>'
            '${'meeting_id'.tr}: ${meeting.meetingDataBaseID} <br/>'
            '${'password'.tr}: ${meeting.meetingPassword} <br/>'
            '${'Join_V.Connct_Meeting'.tr} <br/>'
            '<a href=${meeting.link}>${meeting.link}</a>',
        'settings': settings,
      };

      // 2] call
      final apiResponse = await post(
        url,
        body,
        headers: APIHelper.apiHeaders,
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

      // 4] handle success
      return APIResponseModel(
        succeeded: true,
        data: apiResponse.body['data'],
      );
    } catch (e) {
      // 5] handle failure
      return APIHelper.handleFailure(
        error: e,
        methodName: 'runMeeting',
        fileName: 'meeting_provider',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> joinMeetingOrRoom({
    String? meetingID,
    String? roomToken,
    String? password,
    String? meetingTitle,
    String? userName,
  }) async {
    try {
      // Extra step - special api - construct the url
      final url = (roomToken != null)
          ? '${AppConstants.environment.vlcLayerUrl}/vlc/join_room_meeting_v2/$roomToken'
          : '${AppConstants.environment.vlcLayerUrl}/vlc/join_meeting_v2/$meetingID';

      final body = {
        'user_name': userName ?? AuthService().userName,
        'password': password ?? '',
        'meeting_name': meetingTitle ?? roomToken ?? meetingID,
      };

      final apiResponse = await post(
        url,
        body,
        headers: APIHelper.apiHeaders,
      );

      // [90004] Meaning that I tried to hit a meeting, but it's password
      // protected, so it's a success opertaion, I just need to enter
      // the password and call this api again .. don't snackbar me.
      if (apiResponse.body['status_code'] !=
          AppConstants.meetingNeedsPasswordErrorCode) {
        APIHelper.checkResponseForErrors(apiResponse);
      }

      // handle success.
      // return the meetingLink
      final data = (apiResponse.body['status_code'] ==
              AppConstants.meetingNeedsPasswordErrorCode)
          ? AppConstants.meetingNeedsPasswordErrorCode
          : apiResponse.body['data'];
      return APIResponseModel(
        succeeded: true,
        data: data,
      );
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'joinMeetingOrRoom',
        fileName: 'meeting_Provider',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> checkMeetingBeforeJoin({
    String? meetingID,
    String? roomToken,
    String? password,
  }) async {
    try {
      //? 1] Prepare the body of the API Request
      final token = roomToken ?? '';
      final query = '?url=api/method/variiance.vconnct.api.v1.vconnct_engines'
          '.controllers.v2.meet_engine.check_user_role_and_meeting_status?'
          'token=$token%26meeting_id=$meetingID%26password=$password';

      //? 2] call the api..
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl + query,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //? 3] check the API's response, to avoid using garbage data
      if (apiResponse.body['status_code'] !=
              AppConstants.meetingNeedsPasswordErrorCode &&
          apiResponse.body['status_code'] !=
              AppConstants.meetingHasWaitingRoom) {
        APIHelper.checkResponseForErrors(apiResponse);
      }

      final data = (apiResponse.body['status_code'] ==
              AppConstants.meetingNeedsPasswordErrorCode)
          ? AppConstants.meetingNeedsPasswordErrorCode
          : (apiResponse.body['status_code'] ==
                  AppConstants.meetingHasWaitingRoom)
              ? AppConstants.meetingHasWaitingRoom
              : BeforeJoinModel.fromJson(
                  apiResponse.body['data'],
                );

      return APIResponseModel(
        succeeded: true,
        data: data,
      );

      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'checkMeetingBeforeJoin',
        fileName: 'meeting_Provider',
      );
    }
  }

  //!==================================================
  Future<APIResponseModel> generalSettingsCheck({
    String? meetingID,
    String? roomToken,
  }) async {
    try {
      //? 1] Prepare the body of the API Request
      final token = roomToken ?? '';
      final id = (roomToken == null) ? meetingID : '';
      final query = '?url=api/method/variiance.vconnct.api.v1.vconnct_engines'
          '.controllers.general_settings.check_pre_join_meeting_screen_status?'
          'token=$token%26meeting_id=$id';

      //? 2] call the api..
      final apiResponse = await get(
        AppConstants.environment.apiLayerUrl + query,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      //? 3] check the API's response, to avoid using garbage data
      APIHelper.checkResponseForErrors(apiResponse);
      var data = GeneralSettingsModel.fromJson(apiResponse.body['data']);
      return APIResponseModel(
        succeeded: true,
        data: data,
      );

      //? 5] catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'generalSettingsCheck',
        fileName: 'meeting_Provider',
      );
    }
  }

  //!===========================================================================
  //!===========================================================================
}
