import 'package:flutter/material.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  //*================================ Properties ===============================
  final Widget child;

  final Duration? animationDuration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve reverseCurve;
  final double axisAlignment;
  final Axis axis;
  //*================================ Constructor ==============================

  const CustomAnimatedSwitcher({
    Key? key,
    required this.child,
    this.animationDuration,
    this.reverseDuration,
    this.curve = Curves.fastOutSlowIn,
    this.reverseCurve = Curves.easeInOutQuad,
    this.axisAlignment = 0.0,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final animationDuration =
        this.animationDuration ?? const Duration(milliseconds: 400);
    //*=========================================================================
    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: curve,
      switchOutCurve: reverseCurve,
      reverseDuration: reverseDuration,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axis: axis,
          axisAlignment: axisAlignment,
          child: child,
        ),
      ),
      child: child,
    );
  }
  //*===========================================================================
}
