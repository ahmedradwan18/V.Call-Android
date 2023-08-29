import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../widgets/textfields/custom_text_field.dart';
import '../controllers/rooms_controller.dart';

class RoomDescriptionTextField extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final int minLines;
  final int maxLines;
  final double? verticalContentPaddingFactor;

  //*================================ Constructor ==============================
  const RoomDescriptionTextField({
    Key? key,
    this.minLines = 5,
    this.maxLines = 10,
    this.verticalContentPaddingFactor,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'room_description_placeholder'.tr,
      headerText: 'room_description'.tr,
      onValidateHandler: controller.onValidateRoomDescription,
      textEditingController: controller.roomDescriptionTextController,
      textInputAction: TextInputAction.done,
      verticalContentPaddingFactor: verticalContentPaddingFactor,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
  //*===========================================================================
}
