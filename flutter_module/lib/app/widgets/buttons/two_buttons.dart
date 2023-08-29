import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../data/dismiss_button_state.dart';
import '../../data/enums/button_type.dart';
import '../custom_spacer.dart';
import '../loader.dart';
import 'custom_button.dart';

class TwoButtons extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final VoidCallback? cancelButtonHandler;
  final String cancelButtonLabel;
  final ButtonType cancelButtonType;
  final double? cancelButtonHeight;
  final double? cancelButtonWidth;
  final VoidCallback? applyButtonHandler;
  final String applyButtonLabel;
  final ButtonType applyButtonType;
  final double? applyButtonHeight;
  final double? applyButtonWidth;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? spacerWidth;
  final ButtonStyle? applyButtonStyle;
  final ButtonStyle? cancelButtonStyle;
  final Widget? applyButtonChild;
  final bool isLoading;
  final bool isWhiteLoader;
  final DismissButtonState cancelButtonState;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const TwoButtons({
    super.key,
    this.applyButtonLabel = 'apply',
    this.cancelButtonLabel = 'cancel',
    this.cancelButtonType = ButtonType.outlinedButton,
    this.applyButtonType = ButtonType.elevatedButton,
    this.cancelButtonHandler,
    this.cancelButtonHeight,
    this.cancelButtonWidth,
    this.applyButtonHandler,
    this.applyButtonHeight,
    this.applyButtonWidth,
    this.applyButtonChild,
    this.spacerWidth,
    this.applyButtonStyle,
    this.cancelButtonStyle,
    this.buttonHeight,
    this.buttonWidth,
    this.isLoading = false,
    this.isWhiteLoader = true,
    this.cancelButtonState = DismissButtonState.back,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        //* Cancel
        Flexible(
          child: CustomButton(
            buttonType: cancelButtonType,
            buttonStyle: (cancelButtonType != ButtonType.outlinedButton)
                ? cancelButtonStyle
                : OutlinedButton.styleFrom(
                    foregroundColor: cancelButtonState.color,
                    side: BorderSide(
                      color: cancelButtonState.color,
                      width: 1.5,
                    ),
                  ),
            label: cancelButtonState.label.tr,
            onPressed: cancelButtonHandler,
            width: cancelButtonWidth ?? buttonWidth,
            height: cancelButtonHeight ?? buttonHeight,
          ),
        ),

        //* Save
        CustomSpacer(width: spacerWidth),
        Flexible(
          child: CustomButton(
            buttonType: applyButtonType,
            label: applyButtonLabel.tr,
            onPressed: applyButtonHandler,
            width: applyButtonWidth ?? buttonWidth,
            height: applyButtonHeight ?? buttonHeight,
            buttonStyle: applyButtonHandler == null ? null : applyButtonStyle,
            child: isLoading
                ? Loader(
                    isWhite: isWhiteLoader,
                    padding: 1.0,
                  )
                : applyButtonChild,
          ),
        ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
