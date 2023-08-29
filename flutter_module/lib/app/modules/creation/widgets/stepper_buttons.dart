import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/utils/extensions.dart';
import '../../../data/enums/button_type.dart';
import '../../../widgets/buttons/two_buttons.dart';

class StepperButtons extends StatelessWidget {
  //*================================ Properties ===============================
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;

  //*================================ Constructor ==============================
  const StepperButtons(
      {this.onStepCancel, required this.onStepContinue, Key? key})
      : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final cancelLabel = 'back'.tr;
    final continueLabel = 'continue'.tr;

    //*=========================================================================
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: TwoButtons(
            applyButtonLabel: continueLabel,
            applyButtonHandler: onStepContinue,
            cancelButtonHandler: onStepCancel,
            cancelButtonLabel: cancelLabel,
            cancelButtonType: ButtonType.textButton,
            spacerWidth: (0.15).wf,
            buttonHeight: (0.0555).hf,
          ),
        )
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
