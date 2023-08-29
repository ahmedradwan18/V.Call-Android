import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/text/fitted_text.dart';

import '../core/utils/design_utils.dart';
import '../themes/app_theme.dart';

class DismissibleBackgroundWidget extends StatelessWidget {
  //*================================ Properties ===============================
  final AlignmentDirectional alignmentDirectional;
  final String text;
  final Color color;

  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;

  //*================================ Constructor ==============================
  const DismissibleBackgroundWidget(
      {required this.alignmentDirectional,
      required this.text,
      required this.color,
      required this.verticalPaddingFactor,
      required this.horizontalPaddingFactor,
      required this.horizontalMarginFactor,
      required this.verticalMarginFactor,
      Key? key})
      : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignUtils.getDesignFactor(horizontalPaddingFactor),
        vertical: DesignUtils.getDesignFactor(verticalPaddingFactor),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: DesignUtils.getDesignFactor(horizontalMarginFactor),
        vertical: DesignUtils.getDesignFactor(verticalMarginFactor),
      ),
      alignment: alignmentDirectional,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      child: FittedText(
        text,
        textStyle: AppTheme.appTheme.textTheme.labelLarge,
      ),
    );
  }
  //*===========================================================================
}
