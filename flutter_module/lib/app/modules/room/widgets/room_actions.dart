import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/room/widgets/room_action_tile.dart';
import 'package:flutter_module/app/modules/room/widgets/room_engine_switch_type.dart';
import 'package:get/get.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/models/room/room_model.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/text/custom_text.dart';
import '../controllers/rooms_controller.dart';

class RoomActions extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final RoomModel room;
  //*================================ Constructor ==============================
  const RoomActions({required this.room, super.key});
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*=========================================================================
    final horizontalPadding = (0.05).wf;
    final titleHorizontalPadding = (0.07).wf;
    final verticalPadding = (0.009).hf;
    const double customSpacerHeightFactor = 0.02;
    const double customSpacerHeightFactor6 = 0.01;
    const double customSpacerHeightFactor4 = 0.04;
    const double customSpacerHeightFactor2 = 0.02;
    const double customSpacerHeightFactor3 = 0.05;

    //*=========================================================================
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ListView(
        shrinkWrap: true,
        // mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          const CustomSpacer(
            heightFactor: customSpacerHeightFactor6,
          ),
          //* BottomSheet Title
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: titleHorizontalPadding, vertical: verticalPadding),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: CustomText(
                'actions'.tr,
                style: AppTextTheme.semiBoldHeadline5,
              ),
            ),
          ),
          const CustomSpacer(
            heightFactor: customSpacerHeightFactor,
          ),

          //* Room Engine Type
          RoomEngineSwitcher(room: room),
          // EngineSwitchType(room: room, engineType: room.engineType.index),

          const CustomSpacer(
            heightFactor: customSpacerHeightFactor4,
          ),

          //* Re-Generate Room Link
          CustomActionTile(
            svgPath: AppImagesPaths.regenerateRoomLinksSvgPath,
            title: 'regenrate_room_links'.tr,
            isButton: true,
            onTap: () async => await controller.onRegenerateRoomLinks(
              roomID: room.id,
            ),
          ),
          const CustomSpacer(
            heightFactor: customSpacerHeightFactor2,
          ),

          //* Edit Room Info
          CustomActionTile(
            svgPath: AppImagesPaths.editRoomSvgPath,
            title: 'edit_room_details'.tr,
            onTap: () async => await controller.onEditRoomInfo(room),
          ),
          const CustomSpacer(
            heightFactor: customSpacerHeightFactor2,
          ),

          //* Room Setting
          CustomActionTile(
            svgPath: AppImagesPaths.roomSettingsSvgPath,
            title: 'room_settings'.tr,
            onTap: () async => await controller.onEditRoomSetting(room),
          ),
          const CustomSpacer(
            heightFactor: customSpacerHeightFactor3,
          ),
        ],
      ),
    );
  }
  //*===========================================================================
}
