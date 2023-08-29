import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class CloseIcon extends StatelessWidget {
  //*================================ Properties ===============================

  final double? size;
  final Color? color;
  final VoidCallback? onTap;
  final bool isFilled;
  //*================================ Constructor ==============================
  const CloseIcon({
    Key? key,
    this.size,
    this.color,
    this.onTap,
    this.isFilled = true,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final icon = isFilled
        ? FontAwesomeIcons.solidCircleXmark
        : FontAwesomeIcons.circleXmark;
    //*=========================================================================
    return InkWell(
      onTap: onTap ?? Get.back,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
