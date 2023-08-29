import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/creation/creation_states.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../widgets/buttons/form_button.dart';
import '../../../widgets/custom_spacer.dart';

import '../../../widgets/loader.dart';
import '../../../widgets/locking_widget.dart';
import '../controllers/creation_controller.dart';
import '../widgets/custom_stepper.dart';

class CreationBody extends GetView<CreationController> {
  //*================================ Properties ===============================
  final bool? isCreate;
  final MeetingType? meetingType;
  //*================================ Constructor ==============================
  const CreationBody({
    this.isCreate,
    this.meetingType,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    const double customSpacerHeightFactor1 = 0.005;
    const double customSpacerHeightFactor2 = 0.04;
    const double buttonHeightFactor = 0.067;

    //*=========================================================================
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        //* Create the 3-layer stepper
        Obx(
          () => LockingWidget(
            isLocked: controller.isBusy,
            lockWidget: const Loader(),
            showLockWidget: true,
            child: CustomStepper(isCreate: isCreate, meetingType: meetingType),
          ),
        ),
        const CustomSpacer(heightFactor: customSpacerHeightFactor1),

        //* Button
        Obx(
          () => FormButton(
            onPressed: () async => await controller.onCreateMeetingButtonMethod(
              context: context,
              meetingType: meetingType ?? controller.isMeet,
            ),
            isLoading: controller.isLoading,
            label: controller.createMeetingPageState == CreationStates.edit
                ? 'edit_meeting'.tr
                : 'create_meeting'.tr,
            hasMargin: false,
            horizontalPaddingFactor: 0.0,
            verticalPaddingFactor: 0.0,
            heightFactor: buttonHeightFactor,
          ),
        ),
        const CustomSpacer(heightFactor: customSpacerHeightFactor2),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
