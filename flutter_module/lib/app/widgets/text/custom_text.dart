import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../core/utils/localization_service.dart';

/// Text with predefined style and attributes, to be used when I want the
/// text to be large. e.g. [RoomCard]'s description.
class CustomText extends StatelessWidget {
  //*=============================== Properties ================================
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? minFontSize;
  final AutoSizeGroup? group;
  final List<double>? presetFontSizes;
  final bool useTextOverflow;
  final TextDirection? textDirection;
  final double? maxFontSize;
  final Text? fontFamily;

  //*=============================== Constructor ===============================
  const CustomText(
    this.text, {
    this.style,
    this.maxLines,
    this.textAlign,
    this.minFontSize,
    this.overflow,
    this.presetFontSizes,
    this.group,
    this.fontFamily,
    this.useTextOverflow = false,
    this.textDirection,
    this.maxFontSize,
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final textOverFlow =
        overflow ?? (useTextOverflow ? TextOverflow.ellipsis : null);
    final minFontSize = this.minFontSize ?? 8.0;
    final maxFontSize = this.maxFontSize ?? double.infinity;
    final textDirection =
        this.textDirection ?? LocalizationService.textDirection;
    final textScaleFactor = Get.textScaleFactor;
    final locale = LocalizationService.appLanguage.locale;

    // If i sent [null] as [overflow] then I don't want it to handleOverFlow
    // otherwise just ellipse it.
    //*=========================================================================
    return AutoSizeText(
      text,
      textScaleFactor: textScaleFactor,
      // cuz I can't put it in the [Constructor] as it's not const.
      style: style,
      maxLines: maxLines,
      textAlign: textAlign,

      textDirection: textDirection,
      locale: locale,
      overflow: textOverFlow,
      presetFontSizes: presetFontSizes,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
    );
  }
  //*===========================================================================
}
