import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/helpers/helpers.dart';
import '../../core/utils/design_utils.dart';
import '../../core/utils/extensions.dart';
import 'custom_text_field.dart';

class ReadOnlyTextField extends StatelessWidget {
  //*================================ Properties ===============================
  final String text;
  final String copyText;
  final double? horizontalPadding;
  final double? verticalPadding;

  final String? headerText;
  final IconData? headerIconData;
  final Widget? headerIcon;
  //*================================ Constructor ==============================
  const ReadOnlyTextField({
    required this.text,
    this.copyText = '',
    Key? key,
    this.horizontalPadding,
    this.verticalPadding,
    this.headerText,
    this.headerIconData,
    this.headerIcon,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    final copyIconSize = (0.022).hf;
    final copyMessage = ('text_copied_to_clipboard'.tr).replaceFirst(
      'x',
      copyText,
    );
    //*=========================================================================
    return Stack(
      children: [
        CustomTextField(
          isReadOnly: true,
          initialValue: text,
          headerText: headerText,
          headerIcon: headerIcon,
          headerIconData: headerIconData,
          showSuffixWidget: false,
          showAlwaysVisibleSuffixWidget: true,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          alwaysVisibleSuffixWidget: Icon(
            Icons.copy,
            color: Colors.black,
            size: copyIconSize,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (0.075).wf,
            ),
            child: InkWell(
              borderRadius: DesignUtils.getBorderRadius(),
              onTap: () async =>
                  await Helpers.copyTextToClipboard(text, message: copyMessage),
            ),
          ),
        ),
      ],
    );
  }
  //*===========================================================================
}
