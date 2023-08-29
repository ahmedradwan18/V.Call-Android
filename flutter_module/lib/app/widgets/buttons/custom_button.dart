import 'package:flutter/material.dart';

import '../../core/values/app_constants.dart';
import '../../data/enums/button_type.dart';
import '../../themes/app_theme.dart';
import '../text/animated_text.dart';

class CustomButton extends StatelessWidget {
  //*=============================== Properties ================================
  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final Widget? icon;
  final ButtonStyle? buttonStyle;
  final ButtonType? buttonType;
  final double? width;
  final double? height;
  final double? elevation;

  /// Text in button Styling
  final double minFontSize;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final TextStyle? textStyle;
  final OutlinedBorder? shape;
  final Color? backgroundColor;
  //*=============================== Constructor ===============================
  const CustomButton({
    required this.onPressed,
    this.label,
    this.buttonStyle,
    this.width,
    this.height,
    this.buttonType = ButtonType.elevatedButton,
    this.maxLines = 1,
    this.minFontSize = 8.0,
    this.textAlign = TextAlign.center,
    this.textOverflow = TextOverflow.ellipsis,
    this.textStyle,
    this.icon,
    this.child,
    this.elevation,
    Key? key,
    this.backgroundColor,
    this.shape,
  }) : super(key: key);
  //*================================ Methods ==================================
  _getButtonStyle(BuildContext context) {
    final bool isDisabled = (onPressed == null);
    late final dynamic buttonStyle;

    // Swithc ButtonType
    switch (buttonType) {
      case ButtonType.outlinedButton:
      case ButtonType.outlinedButtonWithIcon:
        if (isDisabled) {
          return AppTheme.getDisabledOutlinedButtonStyle;
        }
        buttonStyle = Theme.of(context).outlinedButtonTheme;

        break;
      case ButtonType.textButton:
        if (isDisabled) {
          return AppTheme.getDisabledTextButtonStyle;
        }
        buttonStyle = Theme.of(context).textButtonTheme;
        break;

      default:
        if (isDisabled) {
          return AppTheme.getDisabledElevatedButtonStyle;
        }
        buttonStyle = Theme.of(context).elevatedButtonTheme;
    }

    return buttonStyle.style.copyWith(
      elevation: MaterialStateProperty.all(elevation),
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      shape: MaterialStateProperty.all(shape),
    );
  }

  //*==================================================
  Widget _getButton({
    required Widget child,
    required BuildContext context,
  }) {
    // If [ButtonStyle] is still null at this point, it means that:
    // 1] (On Pressed) was not null
    // 2] No [ButtonStyle] was provided, so use the default theme and modify
    //    it if necessary.
    final buttonStyle = this.buttonStyle ?? _getButtonStyle(context);

    switch (buttonType) {
      case ButtonType.textButton:
        return TextButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );

      case ButtonType.outlinedButton:
        return OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );

      case ButtonType.elevatedButtonWithIcon:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon!,
          style: buttonStyle,
          label: child,
        );
      case ButtonType.outlinedButtonWithIcon:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon!,
          style: buttonStyle,
          label: child,
        );

      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const animationDuration = AppConstants.shortDuration;
    const animationCurve = Curves.easeInOutQuad;

    final body = child ??
        AnimatedText(
          text: label!,
          defaultText: '',
          maxLines: maxLines,
          minFontSize: minFontSize,
          textAlign: textAlign,
          overflow: textOverflow,
          style: textStyle,
        );

    final result = _getButton(
      context: context,
      child: body,
    );

    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      width: width,
      height: height,
      child: result,
    );
  }
  //*===========================================================================
  //*===========================================================================
}
