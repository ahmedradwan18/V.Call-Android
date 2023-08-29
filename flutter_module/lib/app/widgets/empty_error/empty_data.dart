import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../themes/app_text_theme.dart';
import 'middle_page.dart';

/// Widget to be shown if a certain list is empty
class EmptyData extends StatelessWidget {
  //*================================ Properties ===============================
  final String title;
  final String? subtitle;
  final int? maxTitleLines;
  final Widget? emptyImage;
  final double? emptyImageHeightFactor;
  final TextStyle? textStyle;
  final double? spaceBetweenTextFactor;
  final double? topPaddingFactor;
  final double? bottomPaddingFactor;
  final TextStyle? subtitleTextStyle;
  final double? textHorizontalPaddingFactor;
  final double? textOffsetFactor;
  //*================================ Constructor ==============================

  const EmptyData({
    required this.title,
    this.subtitle,
    this.emptyImage,
    this.emptyImageHeightFactor,
    this.spaceBetweenTextFactor,
    this.topPaddingFactor,
    this.maxTitleLines,
    this.bottomPaddingFactor,
    this.textStyle,
    this.subtitleTextStyle,
    this.textHorizontalPaddingFactor,
    this.textOffsetFactor,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const ScrollPhysics physics = AlwaysScrollableScrollPhysics();
    final textStyle = this.textStyle ?? AppTextTheme.boldBodyText1;
    final topPaddingFactor = this.topPaddingFactor ?? 0.1;
    final spaceBetweenTextFactor = this.spaceBetweenTextFactor ?? 0.035;
    //*=========================================================================
    // inside an expanded.
    return ListView(
      physics: physics,
      // to only take as much as needed.
      children: [
        MiddlePage(
          title: title.tr,
          image: emptyImage,
          emptyImageWidthFactor: emptyImageHeightFactor,
          bottomPaddingFactor: bottomPaddingFactor,
          maxTitleLines: maxTitleLines,
          subtitle: subtitle,
          subtitleTextStyle: subtitleTextStyle,
          textHorizontalPaddingFactor: textHorizontalPaddingFactor,
          titleTextStyle: textStyle,
          textOffsetFactor: textOffsetFactor,
          spaceBetweenTextFactor: spaceBetweenTextFactor,
          topPaddingFactor: topPaddingFactor,
        ),
      ],
    );
  }
  //*===========================================================================

}
