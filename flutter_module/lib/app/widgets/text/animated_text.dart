import 'package:flutter/material.dart';

import '../custom_animated_switcher.dart';
import 'custom_text.dart';

class AnimatedText extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final String defaultText;
  final String text;
  final bool useDefaultText;
  final Duration? duration;
  final AlignmentDirectional alignment;
  final TextStyle? style;
  final int? maxLines;
  final double? minFontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const AnimatedText({
    super.key,
    required this.defaultText,
    required this.text,
    this.useDefaultText = false,
    this.duration,
    this.alignment = AlignmentDirectional.centerStart,
    this.style,
    this.minFontSize,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSwitcher(
      animationDuration: duration,
      child: Align(
        alignment: AlignmentDirectional.center,
        key: ValueKey(text),
        widthFactor: 1,
        child: CustomText(
          // ValueKey to only update when there's an acutal change in sent text
          useDefaultText ? defaultText : text,
          style: style,
          maxLines: maxLines,
          minFontSize: minFontSize,
          textAlign: textAlign,
          overflow: overflow,
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
