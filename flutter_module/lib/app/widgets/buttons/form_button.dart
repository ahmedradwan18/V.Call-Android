import 'package:flutter/material.dart';

import '../../core/utils/design_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import '../loader.dart';
import '../text/custom_text.dart';

class FormButton extends StatelessWidget {
  //*=============================== Properties ================================
  // Function as [GestureDetector] requries it
  final Function()? onPressed;
  final bool isLoading;
  final String label;
  final bool hasMargin;
  final double heightFactor;
  final double? widthFactor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;

  final ButtonStyle? buttonStyle;

  final Color? buttonColor;
  final AlignmentGeometry? alignment;

  final double? topMarginFactor;
  final double? bottomMarginFactor;

  /// DIP, nullable for easy comparison
  final double? height;
  final int maxLines;
  final double borderRadius;

  //*=============================== Constructor ===============================
  const FormButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
    this.hasMargin = true,
    this.heightFactor = 0.06,
    this.widthFactor,
    this.horizontalPaddingFactor = 0.055555,
    this.verticalPaddingFactor = 0.015,
    this.height,
    this.borderRadius = 10,
    this.buttonStyle,
    this.buttonColor,
    this.alignment,
    Key? key,
    this.maxLines = 1,
    this.topMarginFactor,
    this.bottomMarginFactor,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final topMarginFactor = this.topMarginFactor ?? 0.01;
    final bottomMarginFactor = this.bottomMarginFactor ?? 0.03;
    var animationDuratoin = 1500;
    final widthFactor = this.widthFactor ?? (0.2);
    //*=========================================================================
    return GestureDetector(
      onTap: onPressed,
      // to properlly align it 'according to design' within the column.
      child: Align(
        alignment: alignment ?? Alignment.center,
        child: AnimatedContainer(
          alignment: alignment ?? Alignment.center,
          height: height ?? DesignUtils.getDesignFactor(heightFactor),
          width: DesignUtils.getDesignFactor(widthFactor),
          padding: EdgeInsets.symmetric(
            vertical: DesignUtils.getDesignFactor(verticalPaddingFactor),
            horizontal: DesignUtils.getDesignFactor(horizontalPaddingFactor),
          ),
          margin: hasMargin
              ? EdgeInsets.only(
                  top: DesignUtils.getDesignFactor(topMarginFactor),
                  bottom: DesignUtils.getDesignFactor(bottomMarginFactor),
                )
              : EdgeInsets.zero,
          duration: Duration(milliseconds: animationDuratoin),
          curve: Curves.elasticOut,
          decoration: ShapeDecoration(
            shape: isLoading
                ? const CircleBorder()
                : DesignUtils.getRoundedRectangleBorder(radius: borderRadius),
            color: onPressed == null
                ? AppColors.grey
                : buttonColor ?? AppTheme.appTheme.primaryColor,
            shadows: onPressed == null
                ? DesignUtils.getDisabledShadows
                : DesignUtils.getShadows,
          ),
          child: isLoading
              ? const Loader(
                  isWhite: true,
                )
              : CustomText(
                  label,
                  style: AppTheme.appTheme.textTheme.labelLarge,
                  maxLines: maxLines,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
  //*===========================================================================
}
