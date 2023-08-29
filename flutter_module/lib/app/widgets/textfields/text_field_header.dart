import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import '../../core/utils/design_utils.dart';
import '../text/custom_text.dart';

class TextFieldHeader extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final String label;
  final Widget? icon;
  final IconData? iconData;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const TextFieldHeader({
    super.key,
    required this.label,
    this.icon,
    this.iconData,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final style =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11.5);
    final verticalPadding = (0.013).hf;
    //*=========================================================================
    return Row(
      children: [
        //* Icon
        Flexible(
          child: icon ??
              Icon(
                iconData,
                size: DesignUtils.defaultFontAwesoneIconSize,
              ),
        ),

        //* Label
        Flexible(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: verticalPadding,
              bottom: verticalPadding,
              start: (0.02).wf,
            ),
            child: CustomText(
              label,
              style: style,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
