import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/utils/design_utils.dart';
import '../../../data/enums/button_type.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/buttons/custom_button.dart';

class CopyButton extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final double elevation;
  final double? width;
  final String? label;
  final Widget? icon;
  final Function? onPressed;
  final String copyData;
  final String? copyMessgage;
  final Color? buttonColor;
  final double? heightFactor;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const CopyButton({
    Key? key,
    required this.copyData,
    this.elevation = 1.0,
    this.width,
    this.label,
    this.icon,
    this.onPressed,
    this.copyMessgage,
    this.buttonColor,
    this.heightFactor,
  }) : super(key: key);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*=============================== Properties ==============================
    final height = (heightFactor ?? 0.04).hf;
    //*=========================================================================
    return CustomButton(
      elevation: elevation,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        enableFeedback: true,
        shape: DesignUtils.getRoundedRectangleBorder(),
      ),
      width: width,
      buttonType: ButtonType.elevatedButtonWithIcon,
      label: label,
      textStyle: AppTextTheme.boldWhite14BodyText1,
      icon: icon,
      height: height,
      onPressed: () async {
        await Helpers.copyTextToClipboard(
          copyData,
          message: copyMessgage,
        );
      },
    );
  }
  //*===========================================================================
  //*===========================================================================
}
