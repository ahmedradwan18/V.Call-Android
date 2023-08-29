import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/enums/creation/creation_states.dart';
import '../../../data/enums/creation/creation_steps.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../widgets/settings/meeting_settings.dart';
import '../controllers/creation_controller.dart';
import 'meeting_info.dart';
import 'step_subtitle.dart';
import 'step_title.dart';

class CustomStepper extends GetView<CreationController> {
  //*================================ Properties ===============================
  final bool? isCreate;
  final MeetingType? meetingType;
  //*================================ Constructor ==============================
  const CustomStepper({this.isCreate, this.meetingType, Key? key})
      : super(key: key);

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    final step1Tile = 'meeting_information'.tr;
    final step2Tile = 'meeting_settings'.tr;
    final step1Subtile = ('${'title'.tr}, ${'meeting_time'.tr}, ${'etc..'.tr}');
    final step2Subtile = 'allow_recording,allow_mic,etc'.tr;

    //*=========================================================================
    return Obx(
      () => Stepper(
        // TO allow scrolling in the [ListView], it doesn't work otherwise
        physics: const NeverScrollableScrollPhysics(),
        currentStep: controller.currentStepIndex.index,
        // Ternary operator here to enable/disable the button
        onStepContinue:
            controller.isNextStepActive ? controller.incrementStep : null,
        onStepCancel:
            controller.isPrevStepActive ? controller.decrementStep : null,
        onStepTapped: controller.setStepperIndex,
        controlsBuilder: (_, controlsDetails) {
          return const SizedBox.shrink();
        },

        steps: [
          //* First Step
          Step(
            title: StepTitle(step1Tile),
            content: MeetingInfo(isCreate: isCreate ?? false),
            subtitle: StepSubtitle(step1Subtile),
            isActive: controller.currentStepIndex == CreationSteps.infos,
            state: controller.getStepState(CreationSteps.infos),
          ),

          //* Second Step
          Step(
            title: StepTitle(step2Tile),
            content: controller.createMeetingPageState == CreationStates.create
                ? SizedBox(
                    height: 0.4.hf,
                    child: Obx(
                      () => MeetingSettings(
                        settingList: controller.meetingTemplate.roomSettingList!
                            .map((element) {
                          if (element.meetingType == meetingType) {
                            return element;
                          }
                        }).toList()[meetingType == MeetingType.meet ? 1 : 0]!,
                        onToggleSetting:
                            controller.editMeetingRoomSettingLocally,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0.4.hf,
                    child: MeetingSettings(
                      settingList: controller.meetingTemplate.settingList!,
                      onToggleSetting: controller.editMeetingSettingLocally,
                    ),
                  ),
            subtitle: StepSubtitle(step2Subtile),
            isActive: controller.currentStepIndex == CreationSteps.settings,
            state: controller.getStepState(CreationSteps.settings),
          ),
        ],
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
