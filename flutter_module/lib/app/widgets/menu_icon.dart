import 'package:flutter/material.dart';
import '../core/values/app_images_paths.dart';
import 'custom_svg.dart';

class MenuIcon extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final VoidCallback onTap;
  final double? height;
  final Color? color;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const MenuIcon({
    super.key,
    required this.onTap,
    this.color,
    this.height,
  });
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomSvg(
        svgPath: AppImagesPaths.drawerIconSvg,
        fit: BoxFit.scaleDown,
        height: height,
        color: color,
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
