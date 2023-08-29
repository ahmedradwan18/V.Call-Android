import 'package:flutter/material.dart';
import '../core/utils/design_utils.dart';
import '../core/utils/extensions.dart';
import '../themes/app_colors.dart';

/// Generic card to be used througout the application to have uniformity
class CustomCard extends StatelessWidget {
  //*================================ Properties ===============================
  final Widget child;
  final double cardHeightFactor;
  final double cardWidthtFactor;

  final double? hoizontalMargin;
  final double? verticalMarginFactor;
  final double? contentHorizontalPaddingFactor;
  final double? contentVerticalPaddingFactor;
  final Color? backgroundColor;
  final double elevation;
  final double? cardBorderRadius;
  final Color? cardBorderColor;

  /// Whether or not this widget has a specific restricted height
  final bool hasLooseHeight;
  final bool hasLooseWidth;
  final bool showBorder;
  //*================================ Constructor ==============================
  const CustomCard({
    required this.child,
    this.cardHeightFactor = 0.17,
    this.cardWidthtFactor = 0.17,
    this.backgroundColor,
    this.elevation = 8.0,
    this.hoizontalMargin,
    this.verticalMarginFactor = 0.01,
    this.hasLooseHeight = true,
    this.hasLooseWidth = true,
    this.contentHorizontalPaddingFactor,
    this.contentVerticalPaddingFactor,
    this.cardBorderRadius,
    this.cardBorderColor,
    this.showBorder = false,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final height = hasLooseHeight ? null : (cardHeightFactor).hf;
    final width = hasLooseWidth ? null : (cardWidthtFactor).wf;
    final horizontalMargin = hoizontalMargin ?? (0.033).hf;
    final verticalMarginFactor = this.verticalMarginFactor ?? (0.01);
    final contentHorizontalPaddingFactor =
        (this.contentHorizontalPaddingFactor) ?? 0.0;
    final contentVerticalPaddingFactor =
        (this.contentVerticalPaddingFactor) ?? 0.0;
    //*=========================================================================
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        // shadowColor: Colors.transparent,
        color: backgroundColor,
        elevation: elevation,
        clipBehavior: Clip.antiAlias,
        shape: DesignUtils.getRoundedRectangleBorder(
            radius: cardBorderRadius,
            showBorder: showBorder,
            borderColor: showBorder ? cardBorderColor! : AppColors.transparent),

        margin: EdgeInsets.symmetric(
          vertical: (verticalMarginFactor).hf,
          horizontal: horizontalMargin,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: (contentVerticalPaddingFactor).hf,
            horizontal: (contentHorizontalPaddingFactor).wf,
          ),
          child: child,
        ),
      ),
    );
  }
  //*===========================================================================
}
