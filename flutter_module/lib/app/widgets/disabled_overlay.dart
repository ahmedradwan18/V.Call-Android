import 'package:flutter/material.dart';

class DisabledOverlay extends StatelessWidget {
  //*================================ Properties ===============================
  final double opacity;
  //*================================ Constructor ==============================
  const DisabledOverlay({
    Key? key,
    this.opacity = 0.8,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.white.withOpacity(opacity),
        child: Container(),
      ),
    );
  }
  //*===========================================================================
}
