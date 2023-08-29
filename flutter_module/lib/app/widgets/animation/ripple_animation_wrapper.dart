import 'package:flutter/material.dart';
import 'ripple_animation_painter.dart';

import '../../data/enums/ripple_animation_type.dart';

class RipplesAnimationWrapper extends StatelessWidget {
  //*================================ Parameters ===============================
  final Widget child;
  final Animation<double> animation;
  final Color? color;
  final RippleAnimationType? rippleType;
  final double splashSizeFactor;

  /// used for [RippleAnimationType.roundedRectangular] only
  final double? circularRadius;
  //*================================ Constructor ==============================
  const RipplesAnimationWrapper({
    required this.child,
    required this.animation,
    this.color,
    this.rippleType,
    this.circularRadius,
    this.splashSizeFactor = 0.5,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RipplePainter(
        animation: animation,
        color: color,
        rippleType: rippleType,
        circularRadius: circularRadius,
        splashSizeFactor: splashSizeFactor,
      ),
      isComplex: false,
      willChange: false,
      child: child,
    );
  }
  //*===========================================================================
  //*===========================================================================

}
