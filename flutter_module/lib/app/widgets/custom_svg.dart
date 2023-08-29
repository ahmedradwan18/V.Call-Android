import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../core/utils/design_utils.dart';
import '../core/utils/extensions.dart';
import '../core/values/app_images_paths.dart';

class CustomSvg extends StatelessWidget {
  //*================================ Properties ===============================
  final double? heightFactor;
  final double? height;
  final double? widthFactor;
  final String svgPath;
  final AlignmentDirectional alignmentDirectional;
  final BoxFit? fit;
  final Color? color;

  ///If true, will horizontally flip the picture in
  /// [TextDirection.rtl] contexts.
  final bool isRTLAware;

  //*================================ Constructor ==============================
  const CustomSvg({
    Key? key,
    this.heightFactor,
    required this.svgPath,
    this.alignmentDirectional = AlignmentDirectional.center,
    this.isRTLAware = false,
    this.fit,
    this.color,
    this.widthFactor,
    this.height,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final fit = this.fit ?? BoxFit.cover;
    final height = this.height ?? (heightFactor)?.hf;
    //*=========================================================================
    return SvgPicture.asset(
      svgPath,
      alignment: alignmentDirectional,
      matchTextDirection: isRTLAware,
      height: height,
      width: (widthFactor)?.wf ?? double.infinity,
      fit: fit,
      color: color,
      placeholderBuilder: (_) => ClipRRect(
        borderRadius: DesignUtils.getBorderRadius(),
        child: Lottie.asset(
          AppImagesPaths.placeHolderLottie,
          height: (heightFactor)?.hf,
        ),
      ),
    );
  }
  //*===========================================================================
}
