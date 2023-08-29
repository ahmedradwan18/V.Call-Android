import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/api_helper.dart';
import '../../../core/helpers/classroom_helper.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/meet_helper.dart';
import '../../../core/helpers/meeting_helper.dart';

import '../../../core/utils/app_keys.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/logging_service.dart';
import '../../../core/values/app_constants.dart';

import '../../../data/enums/creation/creation_states.dart';
import '../../../data/enums/creation/creation_steps.dart';
import '../../../data/enums/meeting_status.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/creation/meeting_setting_model.dart';
import '../../../data/models/creation/meeting_template.dart';
import '../../../data/models/meeting/classroom_meeting_model.dart';
import '../../../data/models/meeting/meet_meeting_model.dart';
import '../../../data/models/room/room_model.dart';
import '../../../data/models/room/room_settings_model.dart';
import '../../../data/providers/creation_provider.dart';
import '../../../data/providers/meet_provider.dart';
import '../../../data/providers/room_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/meeting_creation_bottom_sheet.dart';
import '../../meetings/controllers/meetings_controller.dart';
import '../../room/controllers/rooms_controller.dart';

class CreationController extends GetxController {
  //!===========================================================================
  //!=========================== Controller Methods ============================
  //!===========================================================================
  //!==================================================
  /// Get all the necessary data for this [View]
  Future<void> _initCreationView() async {
    futureInitCreationView = getRequiredDataForCreationPage()
      ..then((bool succeeded) {
        initCreationView = succeeded;
        hasFetchingError = !succeeded;
      });
  }

  //!==================================================
  Future<void> onRefreshCreationView(
      {CreationStates newState = CreationStates.create}) async {
    createMeetingPageState = newState;
    _initCreationView();
  }
  //!==================================================

  @override
  void onClose() {
    meetingTitleTextFieldController.dispose();
    meetingPasswordTextFieldController.dispose();
    meetingTimeTextFieldController.dispose();
    super.onClose();
  }

  //!===========================================================================
  //!=========================== [Creation] Properties =========================
  //!===========================================================================
  final navigatorKey = AppKeys.customNavigatorsKeysMap[Routes.schedule]!;

  final GlobalKey<FormState> createMeetingFormKey =
      GlobalKey<FormState>(debugLabel: DateTime.now().millisecond.toString());

  late Future<bool> futureInitCreationView;
  late bool initCreationView;

  final meetingTitleTextFieldController = TextEditingController();
  final meetingPasswordTextFieldController = TextEditingController();
  final meetingTimeTextFieldController = TextEditingController(
    text: DateTimeUtils.getStringFromTime(DateTime.now())
        .split(':')
        .take(2)
        .join(' : '),
  );

  final _currentStep = (CreationSteps.infos).obs;
  final _createMeetingPageState = (CreationStates.create).obs;

  // a temporary variable to hold the [meeting] data while the user enters it
  // in the [create meeting] view, to be sent to the API.
  final _meetingTemplate = MeetingTemplate().obs;
  // to be passed from outside of the controller, to use it's data as initial
  // values
  dynamic meetingBeingEdited;

  final _isLoading = false.obs;

  late RxList<RoomModel> _roomList;

  final _hasFetchingError = false.obs;

  final shareWidgetKey = GlobalKey();

  final _isMeet = (MeetingType.meet).obs;

  //!===========================================================================
  //!======================== [Creation] Getters/Setters =======================
  //!===========================================================================
  MeetingTemplate get meetingTemplate => _meetingTemplate.value;
  set meetingTemplate(MeetingTemplate newValue) => _meetingTemplate(newValue);

  CreationStates get createMeetingPageState => _createMeetingPageState.value;
  set createMeetingPageState(newVal) => _createMeetingPageState(newVal);

  bool get isLoading => _isLoading.value;
  set isLoading(bool newValue) => _isLoading(newValue);

  bool get isBusy => _isLoading.value;

  bool get hasFetchingError => _hasFetchingError.value;
  set hasFetchingError(bool newValue) => _hasFetchingError(newValue);

  MeetingType get isMeet => _isMeet.value;
  set isMeet(MeetingType newValue) => _isMeet(newValue);

  List<RoomModel> get activeRoomList =>
      _roomList.where((room) => room.isActive).toList();

  //?======================= Stepper Getters/Setters ===========================
  CreationSteps get currentStepIndex => _currentStep.value;

  /// Whether or not the [Contiue] button is active in the [Stepper] above
  bool get isNextStepActive => _currentStep.value != CreationSteps.values.last;

  /// Whether or not the [Back] button is active in the [Stepper] above
  bool get isPrevStepActive => _currentStep.value != CreationSteps.values.first;

  //!===========================================================================
  //!=========================== [Creation] Methods ============================
  //!===========================================================================

  //?============================= Create Methods ==============================
  void _clearMeetingTemplate() {
    // must clear both ways in this case, to have the change appear on UI.
    meetingTitleTextFieldController.clear();
    meetingPasswordTextFieldController.clear();
    editMeetingTemplate(clear: true);
  }

  //!==================================================
  Future<bool> getRequiredDataForCreationPage() async {
    try {
      LoggingService.information(
        'User Entered Create Meeting Page with state '
        ': [$createMeetingPageState]',
      );

      // CREATE
      if (_createMeetingPageState.value == CreationStates.create) {
        return (await _getDataForCreateState());

        // EDIT
      } else if (_createMeetingPageState.value == CreationStates.edit) {
        editMeetingTemplate(
          title: meetingBeingEdited?.meetingTitle,
          roomID: meetingBeingEdited?.roomID,
          roomTitle: meetingBeingEdited?.roomTitle,
          inputDate: DateTimeUtils.getDateFromString(
            meetingBeingEdited!.meetingDate,
          ),
          inputTime: meetingBeingEdited?.meetingTime,
          password: meetingBeingEdited?.meetingPassword,
          id: meetingBeingEdited?.meetingDataBaseID,

          engineType: meetingBeingEdited?.engineType,

          // [inivtedContacts] and [SettingList]
          // will be populated at the [_getDataForEditState]
        );

        // update the [TextFields] to reflect the new vals.
        meetingTimeTextFieldController.text =
            meetingBeingEdited!.meetingTime.split(':').take(2).join(' : ');
        meetingTitleTextFieldController.text = meetingBeingEdited!.meetingTitle;
        meetingPasswordTextFieldController.text =
            meetingBeingEdited!.meetingPassword ?? '';

        return _getDataForEditState();
      }

      return true;
    }

    // catch any errors
    catch (e) {
      LoggingService.error(
        'Error at Method:getRequiredDataForCreationPage'
        ' -- creation_controller.dart',
        e,
        StackTrace.current,
      );

      return false;
    }
  }

  //!==================================================
  Future<bool> _getDataForCreateState() async {
    try {
      final success = await _getUserRoomsAndContacts();
      if (!success) return false;

      final fetchRoomSettingSuccess = await getRoomDefaultMeetingSettings(
        roomID: activeRoomList.first.id,
      );

      // Use the Obtained values [Room,Contacts, etc..] in [meetingTamplate]
      _clearMeetingTemplate();
      return fetchRoomSettingSuccess;
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getDataForCreateState -- creation_controller.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  bool _checkFutureResult(List<bool> result) {
    return ((result is! Error) &&
        (result is! Exception) &&
        result.every((element) => element == true));
  }

  //!==================================================
  Future<bool> _getUserRoomsAndContacts() async {
    try {
      final result = await Future.wait(
        [
          _getUserRoomList(),
        ],
        eagerError: true,
      );
      return _checkFutureResult(result);
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getUserRoomsAndContacts -- creation_controller.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  Future<bool> _getUserRoomList() async {
    try {
      //LOG
      LoggingService.information('User Got Room List');

      final roomsController = Get.find<RoomsController>();
      // get a reference to [RoomList] in [RoomController] to rebuild the UI
      // at [CrationView] when a room is added at [RoomView]
      _roomList = roomsController.roomList;

      // All is Good
      if (_roomList.isNotEmpty) return true;

      // if the user room list is empty, get it.
      await roomsController.onRefreshRooms();

      return true;
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getUserRoomList -- creation_controller.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  Future<bool> getRoomDefaultMeetingSettings({
    required String roomID,
  }) async {
    //? Logg
    LoggingService.information('User Fetched UserDefaultMeetingSettings');

    if (isBusy) return false;
    isLoading = true;
    //? Fetch the [Settings] for this meeting
    final meetingSettingList =
        await RoomProvider().getRoomDefaultMeetingSettings(
      roomID: roomID,
    );
    isLoading = false;

    if (meetingSettingList == null) {
      APIHelper.showAPIResponseSnackbar(
        APIResponseModel(
          succeeded: false,
          data: (AppConstants.somethingWentWrongText).tr,
        ),
      );
      return false;
    }

    //? add them to MeetingTemplate
    _updateRoomMeetingSettingList(meetingSettingList);
    return true;
  }

  //!==================================================
  MeetingType? _getRoomEngineTypeForMeetingTemplate(
      bool clear, MeetingType? engineType) {
    try {
      return clear ? _roomList.first.engineType : engineType;
    } catch (e) {
      return null;
    }
  }

  //!==================================================
  String? _getRoomIDForMeetingTemplate(bool clear, String? roomID) {
    try {
      return clear ? _roomList.first.id : roomID;
    } catch (e) {
      return null;
    }
  }

  //!==================================================
  String? _getRoomTitleForMeetingTemplate(bool clear, String? roomTitle) {
    try {
      return clear ? _roomList.first.title : roomTitle;
    } catch (e) {
      return null;
    }
  }

  //!=================================================
  /// [context] to hide keyboard with if needed
  /// Creates the meeting at the [ERP],
  Future<APIResponseModel> createMeeting(
      BuildContext context, MeetingType engineType) async {
    //LOG
    LoggingService.information(
      'User to create a meeting at ERP with title: ${meetingTemplate.title}',
    );

    var jsonMeetingSettings = meetingTemplate.jsonSettings(engineType);
    var groupSettingList = meetingTemplate.roomSettingList?.map(
      (e) {
        if (e.meetingType == engineType) {
          return e;
        }
      },
    ).toList()[engineType == MeetingType.meet ? 1 : 0]!;
    editMeetingTemplate(settingList: groupSettingList as RoomSettingsModel);
    // create the meeting at the [ERP]
    return CreationProvider().createMeetingAtERP(
        meetingTemplate: meetingTemplate,
        engineType: engineType,
        settings: jsonMeetingSettings);
  }

  //!=================================================
  Future<void> onCreateMeetingButtonMethod(
      {required BuildContext context, required MeetingType meetingType}) async {
    //validate data

    if (!createMeetingFormKey.currentState!.validate()) {
      // data is not valid ..
      _currentStep(CreationSteps.infos);
      return;
    }

    Helpers.hideKeyboard();

    editMeetingTemplate(engineType: meetingType);

    // show loading indicator
    isLoading = true;

    if (createMeetingPageState == CreationStates.create) {
      await _handleMeetingCreation(context: context, meetingType: meetingType);
    } else {
      await _handleMeetingEdit(meetingType);
    }

    // hide Loding indicator
    isLoading = false;

    // reset the state
    _createMeetingPageState(CreationStates.create);

    // reset the stepper state
    _currentStep(CreationSteps.infos);
  }

  //!==================================================
  Future<void> _handleMeetingCreation(
      {required BuildContext context, required MeetingType meetingType}) async {
    try {
      final response = await createMeeting(context, meetingType);
      if (!(response.succeeded)) {
        APIHelper.showAPIResponseSnackbar(response);
        return;
      }

      // All is Good.
      // Add Locally
      final meeting = response.data;

      // Decide what to do based on the meeting type [current/scheduled]
      meetingTemplate.isScheduled
          ? await _scheduleMeeting(meeting)
          : await _handleMeetingRun(meeting: meeting, meetingType: meetingType);

      Helpers.dismissOverlays();
    } catch (e) {
      LoggingService.error(
        'Error at Method:_handleMeetingCreation -- creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  Future<void> _handleMeetingRun(
      {required dynamic meeting, required MeetingType meetingType}) async {
    try {
      // Log
      LoggingService.information(
        'User runned a meeting with Title: ${meeting.meetingTitle}',
      );

      // Open Bottom sheet
      await Helpers.openBottomSheet(
        bottomSheet: MeetingCreationBottomSheet(
          meeting: meeting,
          onRunMeeting: () async =>
              await _runMeeting(meeting: meeting, type: meetingType),
          shareWidgetKey: shareWidgetKey,
        ),
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:_handleMeetingRun --' ' creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  Future<bool> _runMeeting(
      {required dynamic meeting, required MeetingType type}) async {
    try {
      isLoading = true;
      final bool isRunning;
      if (type == MeetingType.classroom) {
        isRunning = await ClassroomHelper.runMeeting(meeting);

        meeting = ClassroomMeetingModel.fromOld(
          oldMeeting: meeting,
          newStatus: MeetingStatus.started,
        );
        // only dismiss the popup if the meeting run was a success.
        if (isRunning) Get.back();
      } else {
        final apiRespons =
            await MeetProvider().runMeetOnSchedule(meeting.meetingDataBaseID);

        isRunning = await MeetHelper.runMeet(meetingData: apiRespons.data);

        meeting = MeetMeetingModel.fromOld(
          oldMeeting: apiRespons.data,
          newStatus: MeetingStatus.started,
        );
        // only dismiss the popup if the meeting run was a success.
        if (isRunning) {
          Get.back();
        }
      }

      // Add meeting locally
      MeetingHelper.insertUpcomingMeetingLocally(meeting);
      isLoading = false;
      return isRunning;
    } catch (e) {
      LoggingService.error(
        'Error at Method:_runMeeting -- creation_controller.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  // //!==================================================
  Future<void> _scheduleMeeting(meeting) async {
    MeetingHelper.insertUpcomingMeetingLocally(meeting);

    // // Setup Notification Reminder
    // await NotificationService.scheduleMeetingNotification(
    //   title: meeting.meetingTitle,
    //   time: meeting.meetingTime,
    //   date: meeting.meetingDate,
    // );
    isLoading = false;

    Get.back(closeOverlays: true);
    // Get.delete<CreationController>();

    // // Change App View
    // await Get.find<HomeController>().onChangeAppView(AppViews.meeting);
  }

  //!==================================================
  Future<void> _handleMeetingEdit(MeetingType engineType) async {
    try {
      var jsonMeetingSettings = meetingTemplate.settingList?.toJson();

      // Call the API
      final editedMeeting = await CreationProvider().editMeeting(
        meetingTemplate: meetingTemplate,
        settings: jsonMeetingSettings?['settings'],
        engineType: engineType,
      );
      if (editedMeeting == null) return;

      // show snackbar
      APIHelper.showAPIResponseSnackbar(
        APIResponseModel(
          succeeded: true,
          data: 'meeting_edit_success'.tr,
        ),
      );

      // Replace the meeting locally
      final meetingsController = Get.find<MeetingsController>();
      meetingsController.editMeetingLocally(editedMeeting);

      // // Setup a Notification Reminder
      // await NotificationService.scheduleMeetingNotification(
      //   title: editedMeeting.meetingTitle,
      //   time: editedMeeting.meetingTime,
      //   date: editedMeeting.meetingDate,
      // );

      // Navigate to MeetingsView
      // await Get.find<HomeController>().onChangeAppView(AppViews.meeting);
    } catch (e) {
      LoggingService.error(
        'Error at Method:_handleMeetingEdit --' ' creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!===========================================================================
  //!============================= [Edit] Methods ==============================
  //!===========================================================================
  void editMeetingTemplate({
    String? title,
    String? password,
    String? roomID,
    String? roomTitle,

    /// Meeting's Database ID.
    String? id,
    DateTime? inputDate,

    /// NOT [TimeOfDay] to use the [.difference] method
    String? inputTime,
    bool? isScheduled,

    // clear all the data for this MeetingTemplate
    bool clear = false,
    List<RoomSettingsModel>? roomSettingList,
    RoomSettingsModel? settingList,
    MeetingType? engineType,
  }) {
    try {
      // special handlation for time as it's in a Read-Only textField,
      // for validation purposes
      final newDate = DateTime.now();

      if (inputTime != null || clear) {
        inputTime ??= DateTimeUtils.getStringFromTime(newDate);
        meetingTimeTextFieldController.text =
            inputTime.split(':').take(2).join(' : ');
      }

      _meetingTemplate.update((val) {
        //* Title
        val!.title = clear ? '' : title ?? val.title;

        //* Password
        val.password = clear ? '' : password ?? val.password;

        //* roomID
        val.roomID = _getRoomIDForMeetingTemplate(clear, roomID) ?? val.roomID;

        //* roomTitle
        val.roomTitle =
            _getRoomTitleForMeetingTemplate(clear, roomTitle) ?? val.roomTitle;

        //* ID
        val.id = clear ? '' : id ?? val.id;

        //* Engine Type
        val.engineType =
            _getRoomEngineTypeForMeetingTemplate(clear, engineType) ??
                val.engineType;
        isMeet = _getRoomEngineTypeForMeetingTemplate(clear, engineType) ??
            val.engineType;

        //* Date
        val.date = clear
            ? DateTimeUtils.getStringFromDate(DateTime.now())
            : (inputDate == null)
                ? val.date
                : DateTimeUtils.getStringFromDate(inputDate);

        //* Time
        val.time = clear
            ? DateTimeUtils.getStringFromTime(newDate)
            : (inputTime == null)
                ? val.time
                : (inputTime);

        if (inputDate != null || inputTime != null || clear) {
          val.isScheduled = !DateTimeUtils.hasDatePassed(
            dateTime: DateTimeUtils.getDateFromStringAndDate(
              time: inputTime ?? val.time,
              date: inputDate ?? DateTimeUtils.getDateFromString(val.date),
            ),
          );
        }
        val.settingList = settingList ?? val.settingList;
        //* SettingsList [Not Affected by Clear]
        val.roomSettingList = roomSettingList ?? val.roomSettingList;
      });
      LoggingService.information(
        '''User Edited Meeting To Have :
          Type :  ${_meetingTemplate.value.engineType.name}
          Title : ${_meetingTemplate.value.title},
          Password : ${_meetingTemplate.value.password},
          Room Name : ${_meetingTemplate.value.roomTitle},
          Room ID : ${_meetingTemplate.value.roomID},
          Date : ${_meetingTemplate.value.date},
          Time : ${_meetingTemplate.value.time},
          is Scheduled : ${_meetingTemplate.value.isScheduled},
          ''',
      );
    } catch (e) {
      LoggingService.error(
          'Error at Method:editMeetingTemplate -- creation_controller.dart',
          e,
          StackTrace.current);
    }
  }

  //!==================================================
  Future<bool> _getDataForEditState() async {
    try {
      final result = await Future.wait(
        [
          _getUserRoomsAndContacts(),
          _getMeetingInvitedContactList(meetingBeingEdited!),
          _getMeetingSettings(),
        ],
        eagerError: true,
      );

      // Use the Obtained values [Room,Contacts, etc..] in [meetingTamplate]

      return (result is! Error && result is! Exception);
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getDataForEditState -- creation_controller.dart',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  //!==================================================
  Future<void> _getMeetingSettings() async {
    try {
      final meetingSettingList = await ClassroomHelper.getMeetingSettings(
        meetingBeingEdited!.meetingDataBaseID,
      );
      if (meetingSettingList != null) {
        _updateMeetingSettingList(meetingSettingList);
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getMeetingSettings -- creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  void _updateRoomMeetingSettingList(List<RoomSettingsModel> settingList) {
    editMeetingTemplate(roomSettingList: settingList);
  }

  //!==================================================
  void _updateMeetingSettingList(RoomSettingsModel settingList) {
    editMeetingTemplate(settingList: settingList);
  }

  //!==================================================
  // bool to indicate whether or not the method was a success.P
  /// will add the invitedContactList to [ClassroomMeetingModel] to give the functionality
  /// of caching
  Future<void> _getMeetingInvitedContactList(dynamic meeting) async {
    // if it's NOT null then no work is needed.
    if (meeting.invitationList == null) {
      // Log
      LoggingService.information(
        'User Fetched InvitedContacts for meeting with'
        ' Title:[${meeting.meetingTitle}]',
      );

      // Call the API, save the data locally, A.K.A Cache
      final invitaionList = await CreationProvider()
          .getMeetingInvitedContactList(meeting.meetingDataBaseID);

      if (meeting.engineType == MeetingType.classroom) {
        meeting = ClassroomMeetingModel.fromOld(
          oldMeeting: meeting,
          newStatus: meeting.meetingStatus,
          invitationList: invitaionList,
        );
      } else {
        meeting = MeetMeetingModel.fromOld(
          oldMeeting: meeting,
          newStatus: meeting.meetingStatus,
          invitationList: invitaionList,
        );
      }
    }
  }

  //!==================================================
  /// To Edite Meeting Settings Before Creating The Meeting
  Future<void> editMeetingRoomSettingLocally(
      MeetingSettingModel setting) async {
    try {
      final newSettingValue = !setting.isOn.value;

      var newSetting = MeetingSettingModel.toggle(setting, newSettingValue.obs);

      //* Get Settings Engine Type
      var enginIndex = meetingTemplate.roomSettingList!
          .indexWhere((element) => element.meetingType == setting.engineType);

      //* Get Group Settings Index
      var groupIndex = meetingTemplate
          .roomSettingList![enginIndex].meetingGroupsSettings
          .indexWhere(
        (element) {
          return element.groupNameEn == setting.groupName;
        },
      );
      //* Get Setting Index
      var settingIndex = meetingTemplate.roomSettingList![enginIndex]
          .meetingGroupsSettings[groupIndex].meetingSettings
          .indexWhere((element) => element == setting);

      //* Change Setting Value
      meetingTemplate.roomSettingList![enginIndex]
          .meetingGroupsSettings[groupIndex].meetingSettings[settingIndex]
          .isOn(newSetting.isOn.value);

      LoggingService.information(
        'User Edited a meetingSetting =>\nTitle: '
        '${newSetting.titleEn} \nNew Value: ${newSetting.isOn}',
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:editMeetingRoomSettingLocally -- creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  /// To Edite An UpComingMeeting Settings
  Future<void> editMeetingSettingLocally(MeetingSettingModel setting) async {
    try {
      final newSettingValue = !setting.isOn.value;

      var newSetting = MeetingSettingModel.toggle(setting, newSettingValue.obs);

      //* Get Group Settings Index
      var groupIndex =
          meetingTemplate.settingList!.meetingGroupsSettings.indexWhere(
        (element) {
          return element.groupNameEn == setting.groupName;
        },
      );
      //* Get Setting Index
      var settingIndex = meetingTemplate
          .settingList!.meetingGroupsSettings[groupIndex].meetingSettings
          .indexWhere((element) => element == setting);

      //* Change Setting Value
      meetingTemplate.settingList!.meetingGroupsSettings[groupIndex]
          .meetingSettings[settingIndex]
          .isOn(newSetting.isOn.value);

      LoggingService.information(
        'User Edited a meetingSetting =>\nTitle: '
        '${newSetting.titleEn} \nNew Value: ${newSetting.isOn}',
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:editMeetingSettingLocally -- creation_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  /// validate the [Meeting's Time] formTextField in [createMeetingView]
  String? validateMeetingTime(String? _) {
    final meetingTime = DateTimeUtils.getDateFromStringAndDate(
      date: DateTimeUtils.getDateFromString(meetingTemplate.date),
      time: meetingTemplate.time,
    );

    final currentTime = DateTime.now();
    if (meetingTime.isBefore(currentTime) &&
        // to allow creation at the same minute
        (meetingTime.minute != currentTime.minute)) {
      return 'The meeting date is passed'.tr;
    }
    return null;
  }

  //?=========================== Stepper Methods ===============================
  StepState getStepState(CreationSteps step) {
    switch (step) {
      // All the cases for the First[0] Step
      case CreationSteps.infos:
        // If I'm on this step, show the editing Icon
        if (_currentStep.value == step) {
          return StepState.editing;
        } else if (_currentStep.value != step &&
            meetingTemplate.isMeetingInfoFull()) {
          return StepState.complete;
        } else if ((_currentStep.value != step &&
            !meetingTemplate.isMeetingInfoFull())) {
          return StepState.error;
        } else {
          return StepState.indexed;
        }

      // All the cases for the second[1] Step
      case CreationSteps.settings:
        // If I'm on the step, show editing Icon
        if (_currentStep.value == step) {
          return StepState.editing;
        } else if (_currentStep.value.index > step.index) {
          return StepState.complete;
        } else {
          return StepState.indexed;
        }

      default:
        return StepState.indexed;
    }
  }

  //!==================================================
  void setStepperIndex(int newStepIndex) {
    final newStep = CreationSteps.values[newStepIndex];
    // check if user pressed on the step the he is currently on
    if (newStep == _currentStep.value) {
      incrementStep();
    } else {
      _currentStep.value = newStep;
    }

    // re-validate entries to remove any previous error-messages
    // i.e. [Title can't be < 3 chars] error should go away if I
    // enter a few more chars and go to a different step.

    createMeetingFormKey.currentState?.validate();
  }

  //!==================================================
  void incrementStep() {
    if (_currentStep.value.index != CreationSteps.values.last.index) {
      _currentStep.value = CreationSteps.values[_currentStep.value.index + 1];
    }
  }
  //!==================================================

  void decrementStep() {
    if (_currentStep.value.index > 0) {
      _currentStep.value = CreationSteps.values[_currentStep.value.index - 1];
    }
  }

  //?===========================================================================
  //?========================= [Invitations] Methods ===========================
  //?===========================================================================

  void changeMeetingType({required bool ismeet}) {
    isMeet = ismeet ? MeetingType.meet : MeetingType.classroom;
  }
  //!===========================================================================
  //!===========================================================================
}
