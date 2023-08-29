import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/helpers/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../data/enums/meeting_status.dart';
import '../../data/enums/meeting_type.dart';
import '../../data/enums/snack_bar_type.dart';
import '../../data/models/api_response.dart';
import '../../data/models/vlc_view_arguments.dart';
import '../../data/providers/meet_provider.dart';
import '../../data/providers/meeting_provider.dart';
import '../../modules/meetings/controllers/meetings_controller.dart';
import '../utils/design_utils.dart';
import '../utils/logging_service.dart';
import '../values/app_constants.dart';
import 'api_helper.dart';
import 'classroom_helper.dart';
import 'helpers.dart';
import 'meet_helper.dart';

class MeetingHelper {
  //!=============================== Constructor ===============================
  static final MeetingHelper _singleton = MeetingHelper._internal();
  factory MeetingHelper() {
    return _singleton;
  }
  MeetingHelper._internal();
  //!=========================================================================
  //!==================================================
  static Future<void> onShareMeeting({
    required dynamic meeting,
    GlobalKey? widgetKey,
  }) async {
    final copyText = Helpers.getLinkSharingMessage(
      meetingTitle: meeting.meetingTitle,
      link: meeting.link,
      password: meeting.meetingPassword,
      meetingID: meeting.meetingDataBaseID,
    );
    await Helpers.onShareData(
      copyText,
      subject: 'share'.tr,
      sharePositionOrigin: DesignUtils.getWidgetOriginPosition(widgetKey),
    );
  }

  //!==================================================

  static Future<bool> onJoinMeetingOrRoom({
    required TextEditingController meetingIDController,
    required TextEditingController meetingPasswordController,
    TextEditingController? userNameController,
    required GlobalKey<FormState> formKey,
    String? shareLink,
    Function? onShowPasswordField,
    Function? onHidePasswordField,
    Function(MeetingType? engineType)? isModratorFirstJoin,
    bool? isSelectEngineMandatory,
    String? roomToken,
  }) async {
    try {
      // check inputs for sanity
      // if (!(formKey.currentState?.validate() ?? true)) return false;

      // If all is good, hide the Keyboard
      Helpers.hideKeyboard();

      // Extract the Data
      final meetingID = meetingIDController.text.removeAllWhitespace.trim();
      final meetingPassword =
          meetingPasswordController.text.removeAllWhitespace.trim();
      final userName = userNameController?.text.removeAllWhitespace.trim();

      //! check meeting type
      final meetingCheckBeforeJoin = await MeetingProvider()
          .checkMeetingBeforeJoin(
              roomToken: roomToken,
              meetingID: meetingID,
              password: meetingPassword);

      if (!meetingCheckBeforeJoin.succeeded) {
        SnackBarHelper.showSnackBar(
          message: 'you_cant_run_meeting_in_not_active_room'.tr,
          type: SnackBarType.error,
        );

        return false;
      }

      //! IT Has Password
      if (meetingCheckBeforeJoin.data ==
          AppConstants.meetingNeedsPasswordErrorCode) {
        //* Case 1] Meeting Creating is Successful, but it's
        //* Password Protected
        // code to show password field
        if (onShowPasswordField != null) {
          onShowPasswordField();
        }

        // show an informative snackbar
        SnackBarHelper.showSnackBar(
          message: 'this_meeting_has_password'.tr,
          type: SnackBarType.action,
        );

        // meeting was not joined successfully.
        return false;
      }

      // if (meetingCheckBeforeJoin.data == AppConstants.meetingHasWaitingRoom) {
      //   SnackBarHelper.showSnackBar(
      //     message: 'redirect_to_waiting_room_text'.tr,
      //     type: SnackBarType.action,
      //   );
      //   Get.lazyPut(() => WaitingRoomController());
      //   await Get.to(
      //     () => const WaitingRoomView(),
      //     arguments: WaitingRoomArgumants(
      //       meetingID: meetingIDController,
      //       password: meetingPasswordController,
      //       roomToken: roomToken,
      //       formKey: formKey,
      //       userName: userNameController,
      //     ),
      //   );
      //   meetingIDController.clear();
      //   meetingPasswordController.clear();
      //   return false;
      // }

      //! check if meeting not started and is moderator return moderator first
      //! join and make him
      if (meetingCheckBeforeJoin.data?.meetingStatus ==
          MeetingStatus.upcoming) {
        if (meetingCheckBeforeJoin.data.role == 'moderator') {
          if (isModratorFirstJoin != null) {
            isModratorFirstJoin(meetingCheckBeforeJoin.data.engineType);
            if (isSelectEngineMandatory ?? true) {
              // show an informative snackbar
              SnackBarHelper.showSnackBar(
                message: 'choose_event_type'.tr,
                type: SnackBarType.action,
              );
              // meeting was not joined successfully.
            }
            return false;
          }
        }
      }

      // if meeting started
      // Call the API
      final APIResponseModel apiResponse;
      if (meetingCheckBeforeJoin.data.engineType == MeetingType.classroom) {
        apiResponse = await MeetingProvider().joinMeetingOrRoom(
          meetingID: (roomToken != null) ? null : meetingID,
          roomToken: roomToken,
          password: meetingPassword,
          userName: userName,
        );
      } else {
        if (roomToken != null) {
          apiResponse = await MeetProvider().joinRoomWithToken(
            token: roomToken,
            userName: userName,
          );
        } else {
          apiResponse = await MeetProvider().joinMeetWithMeetingId(
            isModerator: meetingCheckBeforeJoin.data.role ?? '',
            meetingID: meetingID,
            userName: userName,
          );
        }
      }

      // added to check as in this success case, the [Message] from api is not
      // empty, it contains the link i'm going to hit.
      if (apiResponse.succeeded) {
        if (apiResponse.data == AppConstants.meetingNeedsPasswordErrorCode) {
          //* Case 1] Meeting Creating is Successful, but it's
          //* Password Protected
          // code to show password field
          if (onShowPasswordField != null) {
            onShowPasswordField();
          }

          // show an informative snackbar
          SnackBarHelper.showSnackBar(
            message: 'this_meeting_has_password'.tr,
            type: SnackBarType.action,
          );

          // meeting was not joined successfully.
          return false;
        }

        //* Case 2] Meeting Creating is Successful, No password is Needed.
        else {
          // clear the meetingID textField
          meetingIDController.clear();

          // Extra cleanups
          if (onHidePasswordField != null) {
            onHidePasswordField();
          }
          // clear and hide the password field
          meetingPasswordController.clear();

          // await AnalyticsService.logJoinMeeting(
          //   parameters: {
          //     'user_ID': AuthService().userID ?? 'Guest',
          //     'is_pro_user': (!AuthService().isUserFree).toString(),
          //     'meeting_id': roomToken ?? meetingID,
          //     'meeting_password': meetingPassword,
          //     'join_time': DateTimeUtils.getStringFromTime(null),
          //     'join_date': DateTimeUtils.getStringFromDate(null),
          //   },
          //   meetingID: roomToken ?? meetingID,
          // );

          // pushes the vlc page onto the UI. [opens VLC]
          // should not share a meeting that is not mine .. so null

          if (meetingCheckBeforeJoin.data.engineType == MeetingType.classroom) {
            await ClassroomHelper.navigateToMeeting(
              VlcViewArugumets(
                url: apiResponse.data,
              ),
            );
          } else {
            await MeetHelper.runMeet(meetingData: apiResponse.data);

            return false;
          }

          // meeting was joined successfully.
          return true;
        }
      }

      // Creating the Meeting has failed
      else {
        APIHelper.showAPIResponseSnackbar(apiResponse);
        return false;
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:onJoinMeetingOrRoom -- meeting_helper.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  void joinClassroomRoomOrMeeting() {}

  //!==================================================
  static void insertUpcomingMeetingLocally(dynamic meeting, {int index = 0}) {
    Get.find<MeetingsController>().insertUpcomingMeeting(
      0,
      meeting,
    );
  }
}
