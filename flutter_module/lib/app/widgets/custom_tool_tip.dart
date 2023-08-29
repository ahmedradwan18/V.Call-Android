import 'package:flutter/material.dart';

import '../core/utils/design_utils.dart';
import '../themes/app_colors.dart';

class CustomToolTip extends StatelessWidget {
  //*=============================== Properties ================================
  final Widget child;
  final String message;
  final Decoration? decoration;
  final TooltipTriggerMode tooltipTriggerMode;
  //*=============================== Constructor ===============================
  const CustomToolTip(
      {required this.child,
      required this.message,
      this.decoration,
      this.tooltipTriggerMode = TooltipTriggerMode.longPress,
      Key? key})
      : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: tooltipTriggerMode,
      message: message,
      decoration: decoration ??
          BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: DesignUtils.getBorderRadius(),
          ),
      child: child,
    );
  }
  //*===========================================================================

}
