import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/design_utils.dart';
import '../core/utils/localization_service.dart';

/// Text with predefined style and attributes, to be used when I want the
/// text to be large. e.g. [RoomCard]'s description.
class CustomSelectableText extends StatelessWidget {
  //*=============================== Properties ================================
  final String nameText;
  final TextStyle? textStyle;
  final int maxLines;
  final int minLines;
  final BoxFit boxFit;
  final TextAlign? textAlign;
  final Color? color;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  //*=============================== Constructor ===============================
  const CustomSelectableText(
    this.nameText, {
    this.textStyle,
    this.maxLines = 1,
    this.minLines = 1,
    this.boxFit = BoxFit.scaleDown,
    this.textAlign,
    this.color,
    this.horizontalPaddingFactor = 0.0,
    this.verticalPaddingFactor = 0.0,
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DesignUtils.getDesignFactor(horizontalPaddingFactor),
        vertical: DesignUtils.getDesignFactor(verticalPaddingFactor),
      ),
      child: SelectableText(
        nameText,
        textScaleFactor: Get.textScaleFactor,
        // cuz I can't put it in the [Constructor] as it's not const.
        style: textStyle,
        maxLines: maxLines,
        textAlign: textAlign,
        minLines: minLines,
        textDirection:
            (LocalizationService.isLTR) ? TextDirection.ltr : TextDirection.rtl,
      ),
    );
  }
  //*===========================================================================
}
