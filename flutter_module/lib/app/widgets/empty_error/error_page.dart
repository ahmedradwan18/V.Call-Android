import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';

import '../../core/values/app_images_paths.dart';
import '../../themes/app_text_theme.dart';
import '../buttons/custom_button.dart';
import '../custom_spacer.dart';
import 'middle_page.dart';

/// Widget to be shown if a certain list is empty
class ErrorPage extends StatelessWidget {
  //*================================ Properties ===============================
  /// WITHOUT .TR
  final String title;
  final String? subtitle;

  final Widget? errorImage;
  final double errorImageHeightFactor;
  final TextStyle? textStyle;
  final double spaceBetweenTextFactor;
  final double topPaddingFactor;
  final double buttonWidth;
  final String imagePath;
  final VoidCallback? onButtonPressed;
  final double bottomPaddingFactor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final double? textHorizontalPaddingFactor;
  final int? maxTitleLines;
  final double? textOffsetFactor;

  //*================================ Constructor ==============================
  const ErrorPage({
    this.title = 'something_went_wrong',
    this.errorImage,
    this.errorImageHeightFactor = 0.25,
    this.textStyle,
    this.spaceBetweenTextFactor = 0.03,
    this.topPaddingFactor = 0.0,
    this.buttonWidth = 0.15,
    this.onButtonPressed,
    this.imagePath = AppImagesPaths.errorLottie,
    this.bottomPaddingFactor = 0.0,
    this.subtitleTextStyle,
    this.titleTextStyle,
    this.textHorizontalPaddingFactor,
    this.subtitle,
    this.maxTitleLines,
    this.textOffsetFactor,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const ScrollPhysics physics = AlwaysScrollableScrollPhysics();
    const double customSpacerHeightFactor1 = 0.015;
    final buttonLabel = 'try_again'.tr;
    final textStyle = this.textStyle ?? AppTextTheme.errorTextStyle;
    final textHorizontalPaddingFactor =
        this.textHorizontalPaddingFactor ?? 0.22;
    //*=========================================================================
    // Dont this way to add buttons or change this layout in the future
    return ListView(
      physics: physics,
      children: [
        MiddlePage(
          title: title.tr,
          image: errorImage ??
              Lottie.asset(
                imagePath,
                height: errorImageHeightFactor,
              ),
          spaceBetweenTextFactor: spaceBetweenTextFactor,
          topPaddingFactor: topPaddingFactor,
          bottomPaddingFactor: bottomPaddingFactor,
          maxTitleLines: maxTitleLines,
          subtitle: subtitle,
          subtitleTextStyle: subtitleTextStyle,
          textHorizontalPaddingFactor: textHorizontalPaddingFactor,
          titleTextStyle: textStyle,
          textOffsetFactor: textOffsetFactor,
        ),
        const CustomSpacer(
          heightFactor: customSpacerHeightFactor1,
        ),
        if (onButtonPressed != null)
          CustomButton(
            onPressed: onButtonPressed,
            label: buttonLabel,
            width: buttonWidth,
          ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================

}
