import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/room/widgets/room_engine_switch_type.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_keys.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../data/models/creation/meeting_setting_model.dart';
import '../../../data/models/room/meeting_group_settings_model.dart';
import '../../../widgets/buttons/form_button.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/settings/setting_body.dart';
import '../../../widgets/settings/setting_group_name.dart';
import '../../../widgets/simple_app_bar.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';
import 'room_description_text_field.dart';
import 'room_title_text_field.dart';

class CreateRoomPage extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final List<MeetingSettingModel> settings;
  //*================================ Constructor ==============================
  const CreateRoomPage({
    required this.settings,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double verticalContentPaddingFactor = (0.02);

    const double customSpacerHeightFactor1 = (0.04);
    const double customSpacerHeightFactor2 = (0.012);
    final verticalPadding = (0.02).hf;
    final horizontalPadding = (0.05).wf;
    final buttonLabel = 'create'.tr;
    //*=========================================================================
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'create_new_room'.tr,
      ),
      body: Form(
        key: AppKeys.roomViewFormKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            // I'm using DIP[Desnsity Independent Pixels] here and not
            // a % of height and width, as I want the text to be at the
            // EXACT location irrespective of the device
            horizontal: horizontalPadding,
            vertical: (verticalPadding),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const CustomSpacer(heightFactor: customSpacerHeightFactor1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CustomText('room_title'.tr),
            ),
            const RoomTitleTextField(
              verticalContentPaddingFactor: verticalContentPaddingFactor,
            ),

            //* Description
            const CustomSpacer(heightFactor: customSpacerHeightFactor2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CustomText('room_description'.tr),
            ),
            const RoomDescriptionTextField(
              verticalContentPaddingFactor: verticalContentPaddingFactor,
            ),
            const CustomSpacer(heightFactor: customSpacerHeightFactor1),
            const RoomEngineSwitcher(),

            //* General Room Settings
            const CustomSpacer(heightFactor: customSpacerHeightFactor2),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionWidget(
                initiallyExpanded: false,
                duration: AppConstants.mediumDuration,
                titleBuilder:
                    (double animationValue, _, bool isExpaned, toogleFunction) {
                  return InkWell(
                    onTap: () => toogleFunction(animated: true),
                    child: SettingsTitle(
                      animationValue: animationValue,
                      isExpaned: isExpaned,
                      settings: const MeetingGroupSettings(
                        meetingSettings: [],
                        groupNameEn: 'General Settings',
                        groupNameAr: 'الإعداد العامة',
                        engineType: MeetingType.classroom,
                        groupIcon:
                            'https://vcloud.variiance.com/link/b6Gmnk3UKfMJ2LLpxozXprGxmSLI0Tlw2zJybPvb.svg',
                      ),
                    ),
                  );
                },
                content: SettingsBody(
                  settings: settings,
                  onToggleSetting: (setting) async {
                    controller.onToggleCreateGeneralSettings(setting);
                  },
                ),
              ),
            ),
            const CustomSpacer(heightFactor: customSpacerHeightFactor1),

            //* Button
            Obx(
              () => FormButton(
                // only send the handler .. any business logic is handled at
                // the controller
                onPressed: () async => await controller.onCreateRoom(context),
                isLoading: controller.isLoading,
                label: buttonLabel,
                hasMargin: false,
                horizontalPaddingFactor: 0.0,
                verticalPaddingFactor: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
}
