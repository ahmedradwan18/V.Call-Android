import 'package:flutter/material.dart';

import '../../data/enums/ripple_animation_type.dart';
import '../../themes/app_colors.dart';

class RipplePainter extends CustomPainter {
  //*================================ Parameters ===============================
  final Color? color;
  final RippleAnimationType? rippleType;
  final Animation<double> animation;
  final double? splashSizeFactor;

  /// used for [RippleAnimationType.roundedRectangular] only
  final double? circularRadius;
  //*================================ Constructor ==============================
  RipplePainter({
    required this.animation,
    required this.color,
    required this.rippleType,
    this.splashSizeFactor,
    this.circularRadius = 15.0,
  }) : super(repaint: animation);
  //*================================= Methods =================================
  void circle(Canvas canvas, Size size, double value) {
    const double angle = 90.0;

    //* splash color
    final opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final color = (this.color ?? AppColors.secondaryColor).withOpacity(opacity);

    //* splash Size
    final height = (size.height * value) * (splashSizeFactor!);
    final width = (size.width * value) * (splashSizeFactor!);
    final center = Offset(size.width / 2, size.height / 2);

    final Paint paint = Paint()..color = color;

    //* size / 2  to get the center
    final Rect rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    switch (rippleType) {
      case RippleAnimationType.circular:
        return canvas.drawArc(rect, angle, angle, true, paint);
      case RippleAnimationType.rectangular:
        return canvas.drawRect(rect, paint);
      case RippleAnimationType.roundedRectangular:
        return canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect,
            Radius.circular(circularRadius!),
          ),
          paint,
        );
      default:
        canvas.drawArc(rect, angle, angle, true, paint);
    }
  }

  //*===========================================================================
  @override
  void paint(Canvas canvas, Size size) {
    for (int wave = 5; wave >= 0; wave--) {
      circle(canvas, size, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => false;
  //*===========================================================================
  //*===========================================================================
}
