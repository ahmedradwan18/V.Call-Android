import 'package:flutter/material.dart';

import '../core/utils/design_utils.dart';

class CustomSpacer extends StatelessWidget {
  //*================================ Properties ===============================
  /// Already implemented [getDesignFactor], just send the factor.
  final double? heightFactor;
  final double? widthFactor;
  final double? height;
  final double? width;
  //*================================ Constructor ==============================
  const CustomSpacer({
    this.heightFactor,
    this.widthFactor,
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    // use absolute height/width [in dip] if not null
    // else use factors [Height * 0.01] if not null
    // else I want a specific sizedBox [for height only or for width only]
    // so use that value only and the other one gets a 0.0
    return SizedBox(
      height: height ?? DesignUtils.getDesignFactor(heightFactor ?? 0),
      width: width ?? DesignUtils.getDesignFactor(widthFactor ?? 0),
    );
  }
  //*===========================================================================

}
