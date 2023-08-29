import 'package:flutter/material.dart';

import '../core/utils/logging_service.dart';

class CustomAssetImage extends StatelessWidget {
  //*================================ Properties ===============================
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color? fallbackIconColor;
  final double? fallbackIconSize;
  final Widget? fallbackWidget;
  final IconData? fallbackIconData;
  final Color? color;

  //*================================ Constructor ==============================
  const CustomAssetImage(
    this.path, {
    this.fit,
    this.height,
    this.width,
    this.fallbackIconColor,
    this.fallbackIconSize,
    this.fallbackWidget,
    this.fallbackIconData,
    this.color,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final fit = this.fit ?? BoxFit.scaleDown;
    //*=========================================================================
    return Image.asset(
      path,
      fit: fit,
      width: width,
      color: color,
      height: height,
      errorBuilder: (_, error, stackTrace) {
        LoggingService.error(
          'Error at loading Image from Source\n[$path]\nimage from netwrok'
          ' -- CourseHeroImage.dart',
          error,
          StackTrace.current,
        );
        return fallbackWidget ??
            Icon(
              fallbackIconData,
              color: fallbackIconColor,
              size: fallbackIconSize,
            );
      },
    );
  }
  //*===========================================================================
}
