import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/room/widgets/room_setting_page_body.dart';
import 'package:flutter_module/app/themes/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/room/room_model.dart';
import '../../../widgets/buttons/two_buttons.dart';
import '../../../widgets/empty_error/error_page.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/locking_widget.dart';
import '../../../widgets/simple_app_bar.dart';
import '../controllers/rooms_controller.dart';

class RoomSettingPage extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final RoomModel room;

  //*================================ Constructor ==============================
  const RoomSettingPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.roomSettingsBackground,
      appBar: SimpleAppBar(
        title: 'room_settings'.tr,
        color: AppColors.roomSettingsBackground,
      ),
      body: FutureBuilder(
        future: controller.getRoomDefaultMeetingSettings(roomID: room.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Obx(
              () => LockingWidget(
                isLocked: controller.isLoading,
                showLockWidget: true,
                lockWidget: const Loader(),
                child: Column(
                  children: [
                    RoomSettingPageBody(
                      room: room,
                      roomSettings: controller.roomDefaultMeetingSettingList,
                      onToggleSetting: controller.onToggleMeetingSetting,
                    ),
                    TwoButtons(
                      buttonWidth: 0.4.wf,
                      spacerWidth: 0.05.wf,
                      buttonHeight: 0.05.hf,
                      applyButtonLabel: 'save'.tr,
                      cancelButtonHandler: () => Get.back(),
                      applyButtonHandler: () =>
                          controller.onSaveRoomSettings(room.id),
                      applyButtonStyle: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          //* Check if it has an error
          else if (snapshot.hasError ||
              ((snapshot.connectionState == ConnectionState.done) &&
                  (!snapshot.hasData))) {
            return ErrorPage(
              topPaddingFactor: (0.125),
              title: (AppConstants.somethingWentWrongText).tr,
            );
          }

          //* By default, show a loading spinner.
          return const Center(child: Loader());
        },
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
