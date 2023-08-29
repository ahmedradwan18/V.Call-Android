import 'package:flutter/material.dart';

import '../core/utils/design_utils.dart';
import 'close_icon.dart';

class TextFieldClearWidget extends StatelessWidget {
  //*================================ Properties ===============================
  final Function()? onClearIconPressed;
  final TextEditingController? textEditingController;
  final double borderRadius;
  final double? size;
  final Color? color;
  //*================================ Constructor ==============================
  const TextFieldClearWidget({
    Key? key,
    this.onClearIconPressed,
    this.textEditingController,
    this.size,
    this.borderRadius = DesignUtils.defaultBorderRadiusValue,
    this.color,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return CloseIcon(
      onTap: onClearIconPressed ?? textEditingController?.clear,
      size: size,
      color: color,
    );
  }
  //*===========================================================================
}
