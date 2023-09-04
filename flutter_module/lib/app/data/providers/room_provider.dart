import 'package:get/get.dart';
import '../../core/helpers/api_helper.dart';
import '../../core/helpers/auth_service.dart';
import '../../core/helpers/helpers.dart';
import '../../core/values/app_constants.dart';
import '../enums/meeting_type.dart';
import '../models/api_response.dart';
import '../models/creation/meeting_setting_model.dart';
import '../models/room/room_model.dart';
import '../models/room/room_settings_model.dart';

/// This file will handle the communication to/from the api responsible for
/// the database [add/edit/remove] so that the controller won't know/care
/// where the data comes from, it just HANDELS IT.
class RoomProvider extends GetConnect {
  //!================================= Methods =================================

  Future<List<RoomModel>?> getRooms() async {
    try {
      //* Prepare the body
      final query = {
        'url': 'api/method/vconnct.v2.room.index'
            '?student_id=${AuthService().userID}'
      };

      //* Call the api..
      final response = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      APIHelper.checkResponseForErrors(response);

      //* All is Good
      final roomList = List<RoomModel>.from(
        response.body['data'].map(
          (jsonRoom) => RoomModel.fromJson(
            jsonRoom,
          ),
        ),
      );

      //* Sort List
      roomList.sort((room1, room2) {
        int activeStatusComparison = 0;
        if (room1.isActive && !room2.isActive) {
          activeStatusComparison = -1;
        }
        if (!room1.isActive && room2.isActive) {
          activeStatusComparison = 1;
        }
        final titleComparision = room1.title.compareTo(room2.title);
        return activeStatusComparison != 0
            ? activeStatusComparison
            : titleComparision;
      });
      return roomList;
    }
    //* Catch any Errors
    catch (e) {
      APIHelper.handleFailure(
        error: e,
        methodName: 'getRooms',
        fileName: 'room_provider',
      );
      return null;
    }
  }
  //!==================================================

  // Generated by [GetX] .. and I might need them in the furue, so dont' make
  // this class [Singelton]
  Future<APIResponseModel> createRoom({
    required String roomTitle,
    required String roomDescription,
    required String engineType,
    required List<MeetingSettingModel> generalSettings,
  }) async {
    try {
      // initialize any parameters used in this API call
      final body = {
        'url': 'api/method/vconnct.v2.room.create',
        'data': {
          'title': roomTitle,
          'student_id': AuthService().userID,
          'description': roomDescription,
          'engine_type': engineType,
          'general_settings': generalSettings.map(
            (meetingSetting) {
              return meetingSetting.toJson();
            },
          ).toList()
        }
      };

      // call the API
      final apiResponse = await post(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      );

      APIHelper.checkResponseForErrors(apiResponse);

      // handle response
      return APIResponseModel(
        succeeded: true,
        data: RoomModel.fromJson(apiResponse.body['data']['room']),
      );
    }

    // Catch any errors
    catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'createRoom',
        fileName: 'room_provider',
      );
    }
  }

  //!===========================================================================
  Future<APIResponseModel> editRoom({
    required RoomModel room,
    required String roomTitle,
    required String roomDescription,
    required String engineType,
  }) async {
    try {
      // create the body for the APIrequest
      final body = {
        'url': 'api/method/vconnct.v1.room.update_room_and_general_settings',
        'data': {
          'student_id': AuthService().userID,
          'room_id': room.id,
          'title': roomTitle,
          'description': roomDescription,
          'engine_type': engineType,
          'general_settings': room.generalSettings!.map(
            (meetingSetting) {
              return meetingSetting.toJson();
            },
          ).toList()
        }
      };

      // call the API
      final response = await put(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      // check the API's response, to avoid using garbage data
      // and to redirect the flow to the error handlation part.
      APIHelper.checkResponseForErrors(response);

      // handle API Success
      // change room details locally to reflect changes w/o refresh
      final editedRoom = RoomModel.fromOld(
        oldRoom: room,
        title: roomTitle,
        description: roomDescription,
        engineType: RoomModel.getMeetingType(engineType),
      );

      //  return success
      return APIResponseModel(
        data: editedRoom,
        succeeded: true,
      );

      // catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'editRoom',
        fileName: 'room_provider',
      );
    }
  }

  //!===========================================================================
  Future<List<RoomSettingsModel>?> getRoomDefaultMeetingSettings({
    required String roomID,
  }) async {
    try {
      final query = {
        'url': 'api/method/vconnct.v2.room.room_settings?'
            '&room_id=$roomID'
      };

      // call the API
      final response = await get(
        AppConstants.environment.apiLayerUrl,
        headers: APIHelper.apiHeaders,
        query: query,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      // check the API's response, to avoid using garbage data
      // and to redirect the flow to the error handlation part.
      APIHelper.checkResponseForErrors(response);

      // handle API Success
      return Helpers.extractRoomSettingsFromJson(
        response.body['data'],
      );

      // catch any errors
    } catch (e) {
      APIHelper.handleFailure(
        error: e,
        methodName: 'getRoomDefaultMeetingSettings',
        fileName: 'room_provider',
      );
      return null;
    }
  }

  //!===========================================================================
  Future<APIResponseModel> editRoomSetting({
    required dynamic setting,
    required String roomID,
    required String engineType,
  }) async {
    try {
      // create the body for the APIrequest
      final body = {
        'url': 'api/method/vconnct.v2.room.update_room_settings',
        'data': {
          'room_id': roomID,
          'engine': engineType,
          'settings': setting,
        }
      };

      // call the API
      final response = await put(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      // check the API's response, to avoid using garbage data
      // and to redirect the flow to the error handlation part.
      APIHelper.checkResponseForErrors(response);

      //  return success
      return APIResponseModel(
        data: response.body['message'],
        succeeded: response.body['status'] == 'success',
      );

      // catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'editRoomSetting',
        fileName: 'room_provider',
      );
    }
  }

  //*==================================================
  Future<APIResponseModel> regenerateRoomLinks({required String roomID}) async {
    try {
      // create the body for the APIrequest
      final body = {
        'url': 'api/method/vconnct.v1.room.generate_links_room',
        'data': {
          'room_id': roomID,
        }
      };

      // call the API
      final response = await put(
        AppConstants.environment.apiLayerUrl,
        body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      // check the API's response, to avoid using garbage data
      // and to redirect the flow to the error handlation part.
      APIHelper.checkResponseForErrors(response);

      // handle API Success
      final success = response.body['status'] == 'success';
      final data = success
          ? RoomModel.fromJson(response.body['data'])
          : response.body['message'];
      return APIResponseModel(
        succeeded: success,
        data: data,
        statusCode: response.statusCode?.toString(),
      );

      // catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'regenerateRoomLinks',
        fileName: 'room_provider',
      );
    }
  }

  //*==================================================
  Future<APIResponseModel> getGenralSettings() async {
    try {
      // create the body for the APIrequest
      final body = '?url=api/method/vconnct.v1.room'
          '.general_settings?user_id=${AuthService().userID}';

      // call the API
      final response = await get(
        AppConstants.environment.apiLayerUrl + body,
        headers: APIHelper.apiHeaders,
      ).timeout(
        APIHelper.apiTimeOutDuration,
      );

      // check the API's response, to avoid using garbage data
      // and to redirect the flow to the error handlation part.
      APIHelper.checkResponseForErrors(response);

      final data = response.body['data']
          .map<MeetingSettingModel>(
            (jsonSetting) => MeetingSettingModel.fromJson(
              jsonSetting,
              '',
              MeetingType.classroom,
            ),
          )
          .toList();
      return APIResponseModel(
        succeeded: true,
        data: data,
        statusCode: response.statusCode?.toString(),
      );

      // catch any errors
    } catch (e) {
      return APIHelper.handleFailure(
        error: e,
        methodName: 'regenerateRoomLinks',
        fileName: 'room_provider',
      );
    }
  }
  //!===========================================================================
  //!===========================================================================
}