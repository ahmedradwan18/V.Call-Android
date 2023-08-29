import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_keys.dart';
import '../../../core/utils/design_utils.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/models/room/meeting_group_settings_model.dart';
import '../../../data/models/room/room_model.dart';
import '../../../widgets/buttons/bottom_sheet_buttons.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/settings/setting_body.dart';
import '../../../widgets/settings/setting_group_name.dart';
import '../../../widgets/simple_app_bar.dart';
import '../controllers/rooms_controller.dart';
import 'room_description_text_field.dart';
import 'room_title_text_field.dart';

class EditRoomPage extends GetView<RoomsController> {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final RoomModel room;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const EditRoomPage({
    super.key,
    required this.room,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeight = 0.03;
    const double customSpacerHeight1 = 0.07;
    const double horizontalPaddingFactor = 0.03;
    const double verticalPaddingFactor = 0.01;

    //*=========================================================================
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'edit_room_details'.tr,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: DesignUtils.getDesignFactor(horizontalPaddingFactor),
            vertical: DesignUtils.getDesignFactor(verticalPaddingFactor),
          ),
          child: Form(
            key: AppKeys.roomViewFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomSpacer(heightFactor: customSpacerHeight1),

                //* Room Title
                const RoomTitleTextField(),

                //* Room Description
                const CustomSpacer(heightFactor: customSpacerHeight),
                const RoomDescriptionTextField(),

                //* General Room Settings
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpansionWidget(
                    initiallyExpanded: false,
                    duration: AppConstants.mediumDuration,
                    titleBuilder: (double animationValue, _, bool isExpaned,
                        toogleFunction) {
                      return InkWell(
                        onTap: () => toogleFunction(animated: true),
                        child: SettingsTitle(
                          animationValue: animationValue,
                          isExpaned: isExpaned,
                          settings: const MeetingGroupSettings(
                            meetingSettings: [],
                            groupNameEn: 'General Settings',
                            groupNameAr: 'الإعداد العامة',
                            engineType: MeetingType.meet,
                            groupIcon:
                                'https://vcloud.variiance.com/link/b6Gmnk3UKfMJ2LLpxozXprGxmSLI0Tlw2zJybPvb.svg',
                          ),
                        ),
                      );
                    },
                    content: SettingsBody(
                      settings: room.generalSettings!,
                      onToggleSetting: (setting) async {
                        controller.onToggleGeneralSettings(setting, room);
                      },
                    ),
                  ),
                ),

                //* ActionButtons
                const CustomSpacer(heightFactor: customSpacerHeight),
                Obx(
                  () => ButtomSheetButtons(
                    onSave: () async => await controller.editRoom(
                      context: context,
                      room: room,
                    ),
                    onCancel: () => controller.initRoomFieldsForEdit(
                      roomTitle: '',
                      roomDescription: '',
                      engineType: MeetingType.classroom.index,
                    ),
                    isLoading: controller.isLoading,
                  ),
                ),
                const CustomSpacer(heightFactor: customSpacerHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
