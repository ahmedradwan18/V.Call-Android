import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  //*================================ Properties ===============================
  final Color? color;
  final VoidCallback? onPressed;
  final Object? result;
  final double? size;
  //*================================ Constructor ==============================
  const BackArrow({
    this.color,
    this.onPressed,
    this.size,
    this.result,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.adaptive.arrow_back,
        color: color,
        size: size,
      ),
      // Must be Navigator so that nestedView pop works
      onPressed: onPressed ?? () => Navigator.of(context).pop(result),
    );
  }
  //*===========================================================================
}
