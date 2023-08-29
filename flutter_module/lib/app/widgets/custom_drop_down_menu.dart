import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/room_title_value_model.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/utils/design_utils.dart';
import '../modules/creation/controllers/creation_controller.dart';
import 'drop_down_menu.dart';
import 'locking_widget.dart';

class CustomDropDownMenu extends GetView<CreationController> {
  //*================================ Constructor ==============================
  const CustomDropDownMenu({Key? key}) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    // to take the focus from the previous field once the user starts to
    // interact with this field.
    final focusScope = FocusScope.of(context);
    final toolTipMessage = 'no_rooms_available'.tr;
    //*=========================================================================
    // [Obx] to listen to changes in [MeetingTemplate] so that when I create
    // a room .. and the meetingTemplate get's updated when I navigate here
    // this widgets knows that
    return Obx(
      () => LockingWidget(
        isLocked: controller.activeRoomList.isEmpty,
        shapeBorder: DesignUtils.getOutlineInputBorder(
          borderColor: Colors.grey.shade300,
        ),
        toolTipMessage: toolTipMessage,
        showMessage: true,
        child: DropDownMenu(
          selectedItem: RoomTitleValueModel(
            roomID: controller.meetingTemplate.roomID,
            roomTitle: controller.meetingTemplate.roomTitle,
            engineType: controller.meetingTemplate.engineType,
          ),
          onChangeHandler: (val) async {
            if (!focusScope.hasFocus) focusScope.nextFocus();
            controller.editMeetingTemplate(
              roomID: val.roomID,
              roomTitle: val.roomTitle,
              engineType: val.engineType,
            );
            await controller.getRoomDefaultMeetingSettings(
              roomID: val.roomID,
            );
          },
          itemList: controller.activeRoomList,
        ),
      ),
    );
  }
  //*===========================================================================
}
