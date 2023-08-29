import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../core/utils/extensions.dart';

import '../../core/values/app_images_paths.dart';
import '../custom_spacer.dart';
import '../custom_svg.dart';

/// Resuable widget between Error/Empty Pages/Data
class MiddlePage extends StatelessWidget {
  //*================================ Properties ===============================
  final String title;
  final String? subtitle;
  final int? maxTitleLines;
  final Widget? image;
  final double? emptyImageWidthFactor;
  final double? spaceBetweenTextFactor;
  final double? topPaddingFactor;
  final double? bottomPaddingFactor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final double? textHorizontalPaddingFactor;
  final double? textOffsetFactor;
  //*================================ Constructor ==============================

  const MiddlePage({
    required this.title,
    this.subtitle,
    this.image,
    this.emptyImageWidthFactor = 0.528,
    this.spaceBetweenTextFactor = 0.0,
    this.topPaddingFactor = 0.0,
    this.maxTitleLines,
    this.bottomPaddingFactor = 0.0,
    this.subtitleTextStyle,
    this.titleTextStyle,
    this.textHorizontalPaddingFactor = 0.0,
    this.textOffsetFactor,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final textOffset = Offset(0, -(textOffsetFactor ?? 0.01).hf);

    final textHorizontalPadding = (textHorizontalPaddingFactor?.wf) ?? 0.0;
    final svgHorizontalPadding = (0.1).wf;
    final svgVerticalPadding = (0.05).hf;

    //*=========================================================================
    // inside an expanded.
    return Column(
      // to only take as much as needed.
      children: <Widget>[
        CustomSpacer(heightFactor: topPaddingFactor),
        image ??
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: svgHorizontalPadding,
                vertical: svgVerticalPadding,
              ),
              child: CustomSvg(
                svgPath: AppImagesPaths.emptyData,
                widthFactor: emptyImageWidthFactor,
              ),
            ),
        CustomSpacer(heightFactor: spaceBetweenTextFactor),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: textHorizontalPadding,
          ),
          child: Transform.translate(
            offset: textOffset,
            child: AutoSizeText.rich(
              TextSpan(
                text: title,
                style: titleTextStyle,
                children: [
                  TextSpan(
                    text: subtitle,
                    style: subtitleTextStyle,
                  ),
                ],
              ),
              maxLines: maxTitleLines,
              minFontSize: 8,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CustomSpacer(
          heightFactor: bottomPaddingFactor,
        ),
      ],
    );
  }
  //*===========================================================================
}
