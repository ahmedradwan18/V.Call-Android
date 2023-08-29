import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../core/utils/design_utils.dart';
import '../../../data/models/room/room_model.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/menu_icon.dart';
import '../controllers/rooms_controller.dart';

class RoomEditButton extends GetView<RoomsController> {
  //*================================ Properties ===============================
  final RoomModel room;
  //*================================ Constructor ==============================
  const RoomEditButton(
    this.room, {
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return MenuIcon(
      onTap: () async => await controller.onEditRoomInfo(room),
      height: DesignUtils.defaultIconSize,
      color: AppColors.grey,
    );
  }
  //*===========================================================================
  //*===========================================================================
}
