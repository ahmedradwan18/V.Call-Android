import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/design_utils.dart';
import '../../data/enums/button_type.dart';
import '../custom_spacer.dart';
import 'custom_button.dart';
import 'form_button.dart';

class ButtomSheetButtons extends StatelessWidget {
  //*================================ Properties ===============================
  final bool isLoading;
  final Function() onSave;
  final Function()? onCancel;
  final String confirmButtonLabel;

  //*================================ Constructor ==============================
  const ButtomSheetButtons({
    Key? key,
    required this.isLoading,
    required this.onSave,
    this.onCancel,
    this.confirmButtonLabel = 'save',
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const Duration animationDuration = Duration(milliseconds: 300);
    const double containerHeightFactor = 0.06;
    const double containerWidthFactor = 0.15;
    const double customSpacerWidthFactor = 0.04;

    //*=========================================================================
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: animationDuration,
          width:
              isLoading ? 0 : DesignUtils.getDesignFactor(containerWidthFactor),
          height: isLoading
              ? 0
              : DesignUtils.getDesignFactor(containerHeightFactor),
          child: CustomButton(
            buttonType: ButtonType.outlinedButton,
            onPressed: (onCancel == null) ? null : onCancel!,
            label: 'cancel'.tr,
          ),
        ),
        CustomSpacer(
          widthFactor: isLoading ? 0 : customSpacerWidthFactor,
        ),
        FormButton(
          isLoading: isLoading,
          onPressed: onSave,
          label: confirmButtonLabel.tr,
          hasMargin: false,
          horizontalPaddingFactor: 0.0,
          verticalPaddingFactor: 0.0,
        ),
      ],
    );
  }
  //*===========================================================================
}
