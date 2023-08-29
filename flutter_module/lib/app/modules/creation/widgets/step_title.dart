import 'package:flutter/material.dart';

import '../../../widgets/text/custom_text.dart';

class StepTitle extends StatelessWidget {
  //*================================ Properties ===============================
  final String title;
  //*================================ Constructor ==============================
  const StepTitle(this.title, {Key? key}) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const int stepTitleMaxLines = 1;
    //*=========================================================================
    return CustomText(
      title,
      maxLines: stepTitleMaxLines,
      useTextOverflow: true,
    );
  }
  //*===========================================================================
}
