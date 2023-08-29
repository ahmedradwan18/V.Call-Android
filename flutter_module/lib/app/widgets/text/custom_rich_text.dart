import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../themes/app_text_theme.dart';
import '../../themes/app_theme.dart';

class CustomRichText extends StatelessWidget {
  //*================================ Properties ===============================
  final String? specialText;
  final TextStyle? contentStyle;
  final TextStyle? specialTextStyle;
  final String content;
  final TextAlign textAlign;
  final GestureRecognizer? specialTextGestureRecognizer;
  final bool addVerticalSpacing;

  const CustomRichText({
    Key? key,
    required this.content,
    this.specialText,
    this.specialTextStyle,
    this.textAlign = TextAlign.center,
    this.contentStyle,
    this.addVerticalSpacing = false,
    this.specialTextGestureRecognizer,
  }) : super(key: key);
  //*================================ Constructor ==============================

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    // this will be my text after I've extracted the special text from it ..
    // to put it in between
    final textList = content.split(specialText ?? '.');
    //*=========================================================================
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: textList.first,
        style: contentStyle ?? AppTheme.appTheme.textTheme.bodyMedium,
        children: <InlineSpan>[
          if (specialText != null)
            TextSpan(
              text: specialText,
              style: specialTextStyle ?? AppTextTheme.bigHighlightedBodyText1,
              recognizer: specialTextGestureRecognizer,
            ),
          if (addVerticalSpacing)
            TextSpan(
              text: '\nVerticalSpace',
              style: TextStyle(
                color: AppTheme.appTheme.scaffoldBackgroundColor,
                fontSize: 5,
              ),
            ),
          TextSpan(
            text: textList.last,
          ),
        ],
      ),
    );
  }
  //*===========================================================================
}
