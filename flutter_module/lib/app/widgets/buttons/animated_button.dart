import 'package:flutter/material.dart';

import '../../core/utils/design_utils.dart';
import '../../data/enums/button_type.dart';
import '../loader.dart';
import 'custom_button.dart';

class AnimatedButton extends StatelessWidget {
  //*=============================== Properties ================================
  // Function as [GestureDetector] requries it
  final Function()? onPressed;
  final bool isLoading;
  final String? label;
  final bool hasMargin;
  final bool isWhite;
  final double? height;
  final double? width;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final ButtonStyle? buttonStyle;
  final Color? backgroundColor;
  final TextAlign textAlign;
  final int maxLines;
  final double? borderRadius;
  final OutlinedBorder? loadingShape;
  final ButtonType? buttonType;
  // for eleveation button w/ icon.
  final Widget? icon;
  final Widget? child;
  //*=============================== Constructor ===============================
  const AnimatedButton({
    required this.onPressed,
    required this.isLoading,
    this.label,
    this.hasMargin = true,
    this.width,
    this.horizontalPaddingFactor = 0.03,
    this.verticalPaddingFactor = 0.01,
    this.height,
    this.borderRadius,
    this.buttonStyle,
    this.backgroundColor,
    this.loadingShape,
    this.textAlign = TextAlign.center,
    super.key,
    this.maxLines = 1,
    this.buttonType,
    this.icon,
    this.isWhite = true,
    this.child,
  });
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double loaderSizeFactor = 0.06;
    final loadingShape = this.loadingShape ??
        (isLoading
            ? const CircleBorder()
            : DesignUtils.getRoundedRectangleBorder(
                radius: borderRadius,
              ));
    final shape = MaterialStateProperty.all(loadingShape);

    //*=========================================================================
    return CustomButton(
      onPressed: onPressed,
      height: height,
      width: width,
      maxLines: maxLines,
      buttonStyle: buttonStyle?.copyWith(shape: shape),
      buttonType: buttonType,
      icon: isLoading ? const SizedBox.shrink() : icon,
      backgroundColor: backgroundColor,
      shape: loadingShape,
      label: isLoading ? null : label,
      child: isLoading
          ? Loader(
              sizeFactor: loaderSizeFactor,
              isWhite: isWhite,
            )
          : child,
    );
  }
  //*===========================================================================
  //*===========================================================================
}
