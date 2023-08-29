import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../widgets/textfields/custom_text_field.dart';
import '../controllers/rooms_controller.dart';

class RoomTitleTextField extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final double? verticalContentPaddingFactor;

  //*================================ Constructor ==============================
  const RoomTitleTextField({
    Key? key,
    this.verticalContentPaddingFactor,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'room_title_placeholder'.tr,
      headerText: 'room_title'.tr,
      onValidateHandler: controller.onValidateRoomTitle,
      textEditingController: controller.roomTitleTextController,
      verticalContentPaddingFactor: verticalContentPaddingFactor,
    );
  }
  //*===========================================================================
  //*===========================================================================
}
