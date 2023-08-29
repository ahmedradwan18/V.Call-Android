import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../core/values/app_images_paths.dart';
import '../themes/app_colors.dart';
import 'custom_asset_image.dart';
import 'custom_svg.dart';

class AppLogo extends StatelessWidget {
  //*=============================== Properties ================================
  final BoxFit? fit;
  final double? widthFactor;
  final double? heightFactor;
  final Color? color;
  final bool iconOnly;

  //*=============================== Constructor ===============================
  const AppLogo({
    this.fit,
    this.widthFactor,
    this.heightFactor,
    this.color,
    Key? key,
    this.iconOnly = false,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final widthFactor = this.widthFactor ?? 0.28;
    final fit = this.fit ?? BoxFit.fitWidth;
    //*=========================================================================
    // this does not have a material as direct parent
    return Material(
      color: AppColors.transparent,
      child: iconOnly
          ? CustomAssetImage(
              AppImagesPaths.logoPath,
              height: heightFactor?.hf,
              fit: fit,
              width: widthFactor.wf,
              color: color,
            )
          : CustomSvg(
              svgPath: AppImagesPaths.vconnctLogoSvg,
              heightFactor: heightFactor,
              widthFactor: widthFactor,
              fit: fit,
              color: color,
            ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
