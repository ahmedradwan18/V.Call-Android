import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/helpers/api_helper.dart';
import '../../../core/helpers/auth_service.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/utils/app_keys.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/logging_service.dart';
import '../../../core/utils/validation_service.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/enums/snack_bar_type.dart';
import '../../../data/models/creation/meeting_setting_model.dart';
import '../../../data/models/room/room_model.dart';
import '../../../data/models/room/room_settings_model.dart';
import '../../../data/providers/room_provider.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/buttons/animated_button.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/text/custom_text.dart';
import '../widgets/create_room_page.dart';
import '../widgets/edit_room_page.dart';
import '../widgets/room_actions.dart';
import '../widgets/room_setting_page.dart';

class RoomsController extends GetxController with GetTickerProviderStateMixin {
  //!===========================================================================
  //!=========================== Controller Methods ============================
  //!===========================================================================
  @override
  void onInit() {
    super.onInit();

    //* Init TabController
    tabBarController = TabController(
      length: tabList.length,
      vsync: this,
      animationDuration: AppConstants.tabControllerAnimationDuration,
    );

    //* Get Rooms
    futureRoomList = RoomProvider().getRooms()
      ..then(
        (data) => roomList.value = data ?? <RoomModel>[],
      );
  }
  //!==================================================

  @override
  void onClose() {
    tabBarController.dispose();
    roomTitleTextController.dispose();
    roomDescriptionTextController.dispose();

    super.onClose();
  }

  //!===========================================================================
  //!============================ [ Rooms] Properties ==========================
  //!===========================================================================
  late final TabController tabBarController;

  final tabList = [
    'my_rooms'.tr,
    'create_room'.tr,
  ];

  /// List of rooms the user has.
  late Future<List<RoomModel>?> futureRoomList;
  final roomList = <RoomModel>[].obs;

  /// TextEdtitingControllers for the [Room Title] textField
  final roomTitleTextController = TextEditingController();

  /// TextEdtitingControllers for the [Room Description] textField
  final roomDescriptionTextController = TextEditingController();

  final _roomEngineType = 0.obs;

  /// a var to check the state of the [RoomButton]
  final _isLoading = false.obs;

  // a var to store whether or not the [editRoom] api succeeded
  // to use in deciding whether or not to show the [success] bottom sheet
  // a.k.a the second child
  // exposed to pass it to a global function to be able to call [Obx] there
  final showSecondBottomSheetChild = false.obs;

  final _roomBeingEditedID = ''.obs;

  final _roomDefultEngieType = (MeetingType.classroom).obs;

  final _isDefultEngieTypeMeet = false.obs;

  // Not final, as it'll be overriden if the user got the settings for multiple
  // rooms
  List<RoomSettingsModel> roomDefaultMeetingSettingList =
      <RoomSettingsModel>[].obs;

  List<MeetingSettingModel> createRoomGeneralSettings =
      <MeetingSettingModel>[].obs;
  //!===========================================================================
  //!========================= [ Rooms] Getters/Setters ========================
  //!===========================================================================

  bool get isLoading => _isLoading.value;
  set isLoading(bool newVal) => _isLoading.value = newVal;

  String get roomBeingEditedID => _roomBeingEditedID.value;
  set roomBeingEditedID(String newValue) => _roomBeingEditedID(newValue);

  int get roomEngineType => _roomEngineType.value;
  set roomEngineType(int newValue) => _roomEngineType(newValue);

  MeetingType get roomDefultEngieType => _roomDefultEngieType.value;
  set roomDefultEngieType(MeetingType newValue) =>
      _roomDefultEngieType(newValue);

  bool get isBusy => isLoading;

  bool get isDefultEngieTypeMeet => _isDefultEngieTypeMeet.value;
  set isDefultEngieTypeMeet(bool newVal) => _isDefultEngieTypeMeet(newVal);

  //!===========================================================================
  //!============================ [ Rooms] Methods =============================
  //!===========================================================================
  Future<void> onTabBarPressed(int newPageIndex) async {
    tabBarController.index = newPageIndex;
  }

  //!============= Form Validation/Submission for Room Methods =================
  String? onValidateRoomTitle(String? text) {
    return ValidationService.roomValidation(
      inputText: text,
      label: 'room_title'.tr,
    );
  }

  //!==================================================
  String? onValidateRoomDescription(String? text) {
    return ValidationService.roomValidation(
      inputText: text,
      label: 'room_description'.tr,
    );
  }

  //!===========================================================================
  //!================== [ Repository Interfact Layer ] Methods =================
  //!===========================================================================
  Future<void> onRefreshRooms() async {
    try {
      await Future.wait(
        [
          futureRoomList = RoomProvider().getRooms()
            ..then(
              // Use the value from API Even if it's null, to overwrite
              // existing data, in case of any changes made by the admin
              // at the [DataBase Layer]
              (data) => roomList.value = data ?? <RoomModel>[],
            ),
        ],
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onRefreshRooms -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  Future<void> onCreateRoom(
    BuildContext? context,
  ) async {
    if (!AppKeys.roomViewFormKey.currentState!.validate()) return;

    Helpers.hideKeyboard();

    _isLoading(true);

    // call the api
    final apiResponse = await RoomProvider().createRoom(
      roomTitle: roomTitleTextController.text.trim(),
      roomDescription: roomDescriptionTextController.text,
      engineType: roomDefultEngieType.label,
      generalSettings: createRoomGeneralSettings,
    );

    Get.back();

    // remove loading indicator
    _isLoading(false);

    if (!(apiResponse.succeeded)) {
      APIHelper.showAPIResponseSnackbar(apiResponse);
      return;
    }

    _handleSuccessfulRoomCreation(apiResponse.data);
  }

  //!=================================================
  void _handleSuccessfulRoomCreation(RoomModel newRoom) {
    // ALL is Good, room was added successfully
    // if everything is okey then:
    // 1) clear the textFields [Name/Description].
    roomTitleTextController.clear();
    roomDescriptionTextController.clear();
    // 2) increment ROom count at UI level,
    AuthService().incrementUserRoomsCount();
    // 3) Add Room Locally
    roomList.insert(0, newRoom);
    // 4) Navigate to [My Rooms]
    tabBarController.animateTo(0);
    // 5] show appropriate snackbar
    SnackBarHelper.showSnackBar(
      message: 'room_created_success'.tr,
      type: SnackBarType.action,
    );
  }

  //!=================================================
  void initRoomFieldsForEdit({
    required String roomTitle,
    required String roomDescription,
    required int engineType,
  }) {
    roomTitleTextController.value = TextEditingValue(text: roomTitle);
    roomDescriptionTextController.value =
        TextEditingValue(text: roomDescription);
    roomEngineType = engineType;
    Get.back();
  }

  //!=================================================
  Future<void> editRoom({
    required BuildContext context,
    required RoomModel room,
  }) async {
    try {
      if (isBusy) return;
      // Validate the data the user entered
      // and return [null] if the data is invalid
      if (!AppKeys.roomViewFormKey.currentState!.validate()) return;

      // hide the keyboard.
      Helpers.hideKeyboard();

      // show the loading Indicator
      _isLoading(true);

      // call the api
      final apiResponse = await RoomProvider().editRoom(
        roomTitle: roomTitleTextController.text.trim(),
        roomDescription: roomDescriptionTextController.text,
        room: room,
        engineType: roomDefultEngieType.label,
      );

      // remove loading indicator
      _isLoading(false);

      // Check Response
      if (!(apiResponse.succeeded)) {
        // only show a snackbar if something went wrong
        APIHelper.showAPIResponseSnackbar(apiResponse);

        return;
      }

      // ALL is Good.
      _handleSuccessfulRoomEdit(
        oldRoom: room,
        newRoom: apiResponse.data,
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onToggleMeetingSetting -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  void _handleSuccessfulRoomEdit({
    required RoomModel oldRoom,
    required RoomModel newRoom,
  }) {
    // if room was added successfully
    // if everything is okey then:
    // 1) set the bool to true, to show the [success] bottomsheet
    showSecondBottomSheetChild.value = true;
    // 2) clear the textFields [Name/Description].
    roomTitleTextController.clear();
    roomDescriptionTextController.clear();
    // 3) replace the room locally with edited room.
    _editRoomLocally(
      oldRoom: oldRoom,
      newRoom: newRoom,
    );

    Get.back();

    final regenrationSuccessText = 'edite_room_success'.tr;

    // 1] Show Snackbar
    SnackBarHelper.showSnackBar(
      message: regenrationSuccessText,
      type: SnackBarType.action,
    );
  }

  //!==================================================
  void _editRoomLocally({
    required RoomModel newRoom,
    RoomModel? oldRoom,
    String? roomID,
  }) {
    final roomIndex = (roomID == null)
        ? roomList.indexOf(oldRoom)
        : roomList.indexWhere((room) => room.id == roomID);

    roomList.replaceRange(
      roomIndex,
      roomIndex + 1,
      [newRoom],
    );
  }

  //!==================================================
  Future<void> onRegenerateRoomLinks({
    required String roomID,
  }) async {
    if (isBusy) return;

    DialogHelper.showCupertinoPopup(
      context: Get.context!,
      child: Material(
        color: AppColors.transparent,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.05.wf),
            height: 0.45.hf,
            width: 0.9.wf,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: AppColors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomSpacer(
                  heightFactor: 0.03,
                ),
                const CustomSvg(
                  svgPath: AppImagesPaths.lightBulb,
                  heightFactor: 0.08,
                ),
                const CustomSpacer(
                  heightFactor: 0.02,
                ),
                CustomText(
                  'generate_new_links_alert'.tr,
                  textAlign: TextAlign.center,
                ),
                const CustomSpacer(
                  heightFactor: 0.03,
                ),
                //TODO()
                const CustomText(
                  'Click ‘Confirm’ to proceed or ‘Cancel’ to go back.”',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Obx(
                  () => AnimatedButton(
                    isLoading: isBusy,
                    onPressed: () async {
                      isLoading = true;
                      await _onRegenerateRoomLinks(roomID: roomID);
                      isLoading = false;
                    },
                    //TODO()
                    label: 'Confirm and regenerate room links',
                    backgroundColor: AppColors.primaryColor,
                    width: 0.7.wf,
                    height: 0.05.hf,
                    buttonStyle: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: AppColors.primaryColor,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
                const CustomSpacer(
                  heightFactor: 0.01,
                ),
                CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppColors.greyTileColor,
                  label: 'back'.tr,
                  textStyle: const TextStyle(color: AppColors.primaryColor),
                  width: 0.7.wf,
                  height: 0.05.hf,
                  buttonStyle: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: AppColors.greyTileColor,
                    shadowColor: Colors.transparent,
                  ),
                ),
                const CustomSpacer(
                  heightFactor: 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //!==================================================
  Future<void> _onRegenerateRoomLinks({
    required String roomID,
  }) async {
    roomBeingEditedID = roomID;
    // Call the API
    final apiResponse = await RoomProvider().regenerateRoomLinks(
      roomID: roomID,
    );

    // Something went wrong
    if (!apiResponse.succeeded) {
      SnackBarHelper.showSnackBar(
        message: apiResponse.data,
        type: SnackBarType.error,
      );
      return;
    }

    // close the BottomSheet
    Get.back(closeOverlays: true);

    // All is Good (2 Steps)
    final regenrationSuccessText = 'regenrate_links_success'.tr;

    // 1] Show Snackbar
    SnackBarHelper.showSnackBar(
      message: regenrationSuccessText,
      type: SnackBarType.action,
    );
    // 2] Modify the Room locally
    _editRoomLocally(
      roomID: roomID,
      newRoom: apiResponse.data,
    );
  }

  //*==================================================
  Future<void> onEditRoomInfo(RoomModel room) async {
    // prepare the values at the textFields
    // set the initialValues at the textFields
    initRoomFieldsForEdit(
      roomTitle: room.title,
      roomDescription: room.description,
      engineType: room.engineType.index,
    );

    // open the bottomSheet
    Get.to(() => EditRoomPage(room: room));
  }

  //*==================================================
  Future<void> onEditRoomSetting(RoomModel room) async {
    Get.to(
      () => RoomSettingPage(
        room: room,
      ),
    );
  }

  //*==================================================
  Future<bool?> getRoomDefaultMeetingSettings({
    required String roomID,
  }) async {
    if (isBusy) return false;

    //? Logg
    LoggingService.information(
      'User Fetched Room\'s Default Meeting\'s Settings',
    );

    //? Fetch the [Settings] for this meeting
    final meetingSettingList =
        await RoomProvider().getRoomDefaultMeetingSettings(
      roomID: roomID,
    );

    //Something went wrong
    if (meetingSettingList == null) return null;

    roomDefaultMeetingSettingList = meetingSettingList;

    return true;
  }

  //*==================================================
  Future<void> onToggleMeetingSetting(MeetingSettingModel setting) async {
    try {
      LoggingService.information(
        '[API] User Edited a meetingSetting =>\nTitle: '
        '${setting.titleEn} \nNew Value: ${!setting.isOn.value}',
      );

      final newSettingValue = !setting.isOn.value;
      final newSetting =
          MeetingSettingModel.toggle(setting, newSettingValue.obs);
      _updateMeetingSettingLocally(oldSetting: setting, setting: newSetting);
    } catch (e) {
      LoggingService.error(
        'Error at Method:onToggleMeetingSetting -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
      isLoading = false;
    }
  }

  //*==================================================
  void _updateMeetingSettingLocally({
    required MeetingSettingModel setting,
    required MeetingSettingModel oldSetting,
  }) {
    //* Get Settings Engine Type Index
    var enginIndex = roomDefaultMeetingSettingList
        .indexWhere((element) => element.meetingType == oldSetting.engineType);

    //* Get Group Settings Index
    var groupIndex = roomDefaultMeetingSettingList[enginIndex]
        .meetingGroupsSettings
        .indexWhere(
      (element) {
        return element.groupNameEn == oldSetting.groupName;
      },
    );
    //* Get Setting Index
    var settingIndex = roomDefaultMeetingSettingList[enginIndex]
        .meetingGroupsSettings[groupIndex]
        .meetingSettings
        .indexWhere((element) => element == oldSetting);

    //* Change Setting Value
    roomDefaultMeetingSettingList[enginIndex]
        .meetingGroupsSettings[groupIndex]
        .meetingSettings[settingIndex]
        .isOn(setting.isOn.value);
  }

  //*==================================================

  void onChangeRoomDefultEngieType(
      {required MeetingType engineType, RoomModel? room}) async {
    if (room == null) {
      roomDefultEngieType = engineType;
      isDefultEngieTypeMeet = (engineType == MeetingType.meet);
      return;
    }

    // show the loading Indicator
    _isLoading(true);

    // call the api
    final apiResponse = await RoomProvider().editRoom(
      roomTitle: room.title,
      roomDescription: room.description,
      room: room,
      engineType: engineType.label,
    );

    // remove loading indicator
    _isLoading(false);

    // Check Response
    if (!(apiResponse.succeeded)) {
      // only show a snackbar if something went wrong
      APIHelper.showAPIResponseSnackbar(apiResponse);

      return;
    }

    // Show snackbar of the success
    SnackBarHelper.showSnackBar(
        message: 'room_engine_type_changed'.tr, type: SnackBarType.information);

    // ALL is Good.
    _editRoomLocally(
      oldRoom: room,
      newRoom: apiResponse.data,
    );

    Get.back(closeOverlays: true);
  }

  //*==================================================
  void onRoomActionPressed(RoomModel room) {
    Helpers.openBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      enableDrag: true,
      backgroundColor: AppColors.white,
      bottomSheet: RoomActions(room: room),
      isDismissible: true,
    );
  }

  //*==================================================
  void onCreateRoomButtonPressed() async {
    try {
      createRoomGeneralSettings.clear();

      var response = await RoomProvider().getGenralSettings();

      createRoomGeneralSettings.addAll(response.data);

      Get.to(() => CreateRoomPage(settings: createRoomGeneralSettings));
    } catch (e) {
      LoggingService.error(
        'Error at Method:onSaveRoomSettings -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  void onSaveRoomSettings(roomId) async {
    try {
      var jsonRoomSettings = roomDefaultMeetingSettingList.map(
        (engineSettings) {
          return engineSettings.toJson();
        },
      ).toList();

      for (var element in jsonRoomSettings) {
        await RoomProvider().editRoomSetting(
          setting: element['settings'],
          roomID: roomId,
          engineType: element['engine'].label,
        );
      }
      Get.back();
      SnackBarHelper.showSnackBar(
          message: 'room_settings_updated'.tr, type: SnackBarType.action);
    } catch (e) {
      LoggingService.error(
        'Error at Method:onSaveRoomSettings -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  void onToggleGeneralSettings(
      MeetingSettingModel setting, RoomModel room) async {
    try {
      LoggingService.information(
        '[API] User Edited a meetingSetting =>\nTitle: '
        '${setting.titleEn} \nNew Value: ${!setting.isOn.value}',
      );

      final newSettingValue = !setting.isOn.value;
      final newSetting =
          MeetingSettingModel.toggle(setting, newSettingValue.obs);
      _updateRoomGeneralSettingsLocally(
          oldSetting: setting, setting: newSetting, room: room);
    } catch (e) {
      LoggingService.error(
        'Error at Method:onToggleGeneralSettings -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  void _updateRoomGeneralSettingsLocally({
    required MeetingSettingModel setting,
    required MeetingSettingModel oldSetting,
    required RoomModel room,
  }) {
    var roomIndex = roomList.indexWhere((element) => element == room);
    var settingsIndex = roomList[roomIndex]
        .generalSettings!
        .indexWhere((element) => element == oldSetting);

    roomList[roomIndex]
        .generalSettings![settingsIndex]
        .isOn(setting.isOn.value);
  }

  //*==================================================
  void onToggleCreateGeneralSettings(MeetingSettingModel setting) async {
    try {
      LoggingService.information(
        '[API] User Edited a meetingSetting =>\nTitle: '
        '${setting.titleEn} \nNew Value: ${!setting.isOn.value}',
      );

      final newSettingValue = !setting.isOn.value;
      final newSetting =
          MeetingSettingModel.toggle(setting, newSettingValue.obs);
      _updateCreateRoomGeneralSettingsLocally(
        oldSetting: setting,
        setting: newSetting,
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:onToggleCreateGeneralSettings -- rooms_controller.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*==================================================
  void _updateCreateRoomGeneralSettingsLocally({
    required MeetingSettingModel setting,
    required MeetingSettingModel oldSetting,
  }) {
    var settingsIndex = createRoomGeneralSettings
        .indexWhere((element) => element == oldSetting);

    createRoomGeneralSettings[settingsIndex].isOn(setting.isOn.value);
  }

  //!===========================================================================
  //!===========================================================================
}
