import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// just a [headerText] in a [fittedBox] in an [Align] widget
/// created as it's being used in different places
class FittedText extends StatelessWidget {
  //*=============================== Properties ================================
  final String nameText;
  final TextStyle? textStyle;
  final int maxLines;
  final BoxFit boxFit;
  final TextAlign textAlign;
  final AlignmentDirectional alignment;
  //*=============================== Constructor ===============================
  const FittedText(
    this.nameText, {
    this.textStyle,
    this.maxLines = 1,
    this.boxFit = BoxFit.scaleDown,
    this.alignment = AlignmentDirectional.centerStart,
    this.textAlign = TextAlign.center,
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FittedBox(
        fit: boxFit,
        child: Text(
          nameText,
          textScaleFactor: Get.textScaleFactor,
          // cuz I can't put it in the [Constructor] as it's not const.
          style: textStyle,
          maxLines: maxLines,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  //*===========================================================================

}
