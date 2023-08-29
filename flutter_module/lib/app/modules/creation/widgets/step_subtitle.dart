import 'package:flutter/material.dart';

import '../../../themes/app_text_theme.dart';
import '../../../widgets/text/custom_text.dart';

class StepSubtitle extends StatelessWidget {
  //*================================ Properties ===============================
  final String subtitle;
  //*================================ Constructor ==============================
  const StepSubtitle(this.subtitle, {Key? key}) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    const int stepSubtitleMaxLines = 2;
    final stepSubtitleTextStyle = AppTextTheme.italicCaption;

    //*=========================================================================
    return CustomText(
      subtitle,
      style: stepSubtitleTextStyle,
      maxLines: stepSubtitleMaxLines,
      useTextOverflow: true,
    );
  }
  //*===========================================================================
}
