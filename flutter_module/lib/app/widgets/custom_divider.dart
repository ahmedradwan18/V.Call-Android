import 'package:flutter/material.dart';

import '../core/utils/design_utils.dart';

class CustomDivider extends StatelessWidget {
  //*================================ Properties ===============================
  final double thickness;
  final Color? color;
  final double indentFactor;
  final double endIndentFactor;

  const CustomDivider({
    Key? key,
    this.thickness = 1.0,
    this.endIndentFactor = 0.01,
    this.indentFactor = 0.01,
    this.color,
  }) : super(key: key);
  //*================================ Constructor ==============================

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      endIndent: DesignUtils.getDesignFactor(endIndentFactor),
      indent: DesignUtils.getDesignFactor(indentFactor),
      color: color,
    );
  }
  //*===========================================================================
}
