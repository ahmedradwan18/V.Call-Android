import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/custom_tool_tip.dart';

@immutable
class ToolButton extends StatelessWidget {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final String? svgPath;
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? tooltip;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const ToolButton({
    super.key,
    this.onPressed,
    this.icon,
    this.svgPath,
    this.tooltip,
  });
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  @override
  Widget build(BuildContext context) {
    return CustomToolTip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox.fromSize(
          size: const Size.fromRadius(18.0),
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: AppColors.primaryColor,
            elevation: 4.0,
            child: (svgPath == null)
                ? icon!
                : CustomSvg(
                    svgPath: svgPath!,
                    fit: BoxFit.scaleDown,
                  ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
