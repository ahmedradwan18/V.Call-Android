import 'package:flutter/material.dart';

class AnimatedSlideScaleWidget extends StatelessWidget {
  //================================ Properties ================================
  // the driver animation
  final Animation<double> animation;
  // the widget to be displayed
  final Widget child;
  // the alignment of the widget at the beginning of the animation
  final Offset startOffset;

  //================================ Constructor ===============================
  const AnimatedSlideScaleWidget({
    required this.animation,
    required this.child,
    required this.startOffset,
    Key? key,
  }) : super(key: key);
  //================================= Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    // To generate Animation<Offset> from the given Animation<double>
    final offsetAnimation = Tween<Offset>(
      begin: startOffset,
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeIn,
        ),
      ),
    );

    final scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.easeIn,
        ),
      ),
    );

    //*=========================================================================
    return SlideTransition(
      position: offsetAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}
