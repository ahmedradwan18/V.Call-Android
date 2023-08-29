import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/utils/extensions.dart';
import '../core/values/app_images_paths.dart';
import '../themes/app_colors.dart';

class Loader extends StatelessWidget {
  //*=============================== Properties ================================
  final Color indicatorColor;
  final Color? materialColor;
  final bool isWhite;
  final double? sizeFactor;
  final double padding;
  //*==================padding============= Constructor ===============================
  const Loader({
    this.indicatorColor = AppColors.primaryColor,
    this.sizeFactor,
    this.materialColor,
    this.isWhite = false,
    this.padding = 5.0,
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final path = isWhite
        ? AppImagesPaths.whiteLoaderLottie
        : AppImagesPaths.loaderLottie;
    final size = (sizeFactor ?? 0.14).hf;
    //*=========================================================================
    return Container(
      color: materialColor,
      padding: EdgeInsets.all(padding),
      child: Lottie.asset(
        path,
        height: size,
      ),
    );
  }
  //*===========================================================================

}
