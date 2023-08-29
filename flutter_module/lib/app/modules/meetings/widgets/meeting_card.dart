import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/disabled_overlay.dart';
import '../../../widgets/dismissible_widget.dart';
import '../controllers/meetings_controller.dart';

import 'custom_meeting_actions.dart';
import 'meeting_card_information.dart';
import 'meeting_card_options.dart';

class MeetingCard extends GetView<MeetingsController> {
  //*=============================== Properties ================================
  final Function onDismissed;

  final dynamic meeting;
  //*=============================== Constructor ===============================
  const MeetingCard({
    required this.meeting,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeightFactor1 = 0.008;
    const double contentHorizontalPaddingFactor = 0.05;
    const double contentVerticalPaddingFactor = 0.016;
    const double elevation = 10.0;

    final hoizontalMargin = (0.02).wf;
    //*=========================================================================
    return DismissibleWidget(
      key: Key(meeting.toString()),
      title: meeting.meetingTitle,
      onDismiss: () async => await onDismissed(
        meeting,
      ),
      name: 'meeting',

      // controls the paddding around the content of the card
      child: Stack(
        children: [
          CustomCard(
            hoizontalMargin: hoizontalMargin,
            contentHorizontalPaddingFactor: contentHorizontalPaddingFactor,
            contentVerticalPaddingFactor: contentVerticalPaddingFactor,
            elevation: elevation,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Meeting Info
                    Expanded(
                      child: MeetingCardInformation(meeting),
                    ),

                    const CustomSpacer(widthFactor: 0.015),
                    //* Meeting Options
                    Obx(
                      () => MeetingCardOptions(
                        runningMeetingsIDList: controller.runningMeetingsIDList,
                        meeting: meeting,
                        onDeleteMeeting: () async =>
                            await controller.onRemoveMeeting(
                          meeting: meeting,
                        ),
                      ),
                    ),
                  ],
                ),

                //* Meeting Actions
                const CustomSpacer(heightFactor: customSpacerHeightFactor1),
                Obx(
                  () => CustomMeetingActions(
                    runningMeetingsIDList: controller.runningMeetingsIDList,
                    meeting: meeting,
                  ),
                ),
                const CustomSpacer(heightFactor: customSpacerHeightFactor1),
              ],
            ),
          ),
          if (!meeting.isActive) const DisabledOverlay(),
        ],
      ),
    );
  }
  //*===========================================================================
}
