import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/custom_tool_tip.dart';

class RoomLinksReGenerationIcon extends AnimatedWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final String roomID;
  final String roomBeingEditedID;
  final void Function()? onPressed;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const RoomLinksReGenerationIcon({
    super.key,
    required this.roomID,
    required this.roomBeingEditedID,
    this.onPressed,
    required AnimationController listenable,
  }) : super(
          listenable: listenable,
        );

  Animation<double> get _progress => listenable as Animation<double>;

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const Color iconColor = AppColors.grey;
    final iconSize = (0.03).hf;
    final tooltip = 'regenrate_room_links'.tr;
    final isIconBeingPressed = (roomID == roomBeingEditedID);
    //*=========================================================================
    return CustomToolTip(
      message: tooltip,
      child: SizedBox(
        height: iconSize,
        child: IconButton(
          padding: EdgeInsets.zero,
          alignment: const AlignmentDirectional(0.8, 0),
          onPressed: onPressed,
          icon: Transform.rotate(
            angle: isIconBeingPressed ? -_progress.value : 0,
            child: Icon(
              Icons.sync,
              color: iconColor,
              size: (iconSize),
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
