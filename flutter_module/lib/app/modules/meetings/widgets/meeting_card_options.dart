import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/modules/meetings/widgets/running_meeting_indicator.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/helpers/auth_service.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/enums/meeting_status.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/locking_widget.dart';

import '../controllers/meetings_controller.dart';

class MeetingCardOptions extends GetView<MeetingsController> {
  //*================================ Properties ===============================
  final dynamic meeting;
  final Function()? onDeleteMeeting;
  final List<String> runningMeetingsIDList;

  //*================================ Constructor ==============================
  const MeetingCardOptions({
    required this.meeting,
    this.onDeleteMeeting,
    required this.runningMeetingsIDList,
    Key? key,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerHeightFactor2 = 0.045;
    const double customSpacerWidthFactor = 0.025;
    const double elevation = 0.0;
    const TextOverflow textOverFlow = TextOverflow.ellipsis;
    const int maxLines = 2;

    // Get it here as it's [Transparent] for the [Tab Bar]
    // final splashColor = AppTheme.appTheme.splashColor;
    final rowTopPadding = (0.01).hf;
    final rowEndPadding = (0.02).wf;
    final recordingTextStyle = AppTextTheme.boldWhiteOverline;
    // final deleteIconToolTip = 'swipe_to_delete'.tr;
    final recordingLabel = 'preview_recording'.tr;
    final recordingWidth = (0.28).wf;
    const iconSize = 0.022;
    final recordingButtonHeight = (0.045).hf;
    final isMeetingRunning =
        ((meeting.meetingStatus == MeetingStatus.started) ||
            (runningMeetingsIDList.contains(meeting.meetingDataBaseID)));
    //*=========================================================================
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            end: rowEndPadding,
            top: rowTopPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isMeetingRunning &&
                  meeting.meetingStatus != MeetingStatus.log)
                InkWell(
                  onTap: () async => await controller.onEditMeeting(meeting),
                  child: const CustomSvg(
                    svgPath: AppImagesPaths.editIcon,
                    color: AppColors.primaryColor,
                    heightFactor: iconSize,
                  ),
                ),

              if (isMeetingRunning)
                const CustomSpacer(widthFactor: customSpacerWidthFactor),
              if (isMeetingRunning) const RunningMeetingIndicator(),

              const CustomSpacer(widthFactor: customSpacerWidthFactor),
              //* Copy Button
              Builder(
                builder: (buildContext) => InkWell(
                  onTap: () => controller.showCopyWidget(
                    context: buildContext,
                    meetingLink: meeting.link,
                    meetingTitle: meeting.meetingTitle,
                    meetingID: meeting.meetingDataBaseID,
                    password: meeting.meetingPassword,
                  ),
                  child: const CustomSvg(
                    svgPath: AppImagesPaths.copyIcon,
                    heightFactor: iconSize,
                  ),
                ),
              ),

              if (!isMeetingRunning)
                const CustomSpacer(widthFactor: customSpacerWidthFactor),

              //* Delete Button
              if (!isMeetingRunning)
                InkWell(
                  onTap: onDeleteMeeting,
                  child: const CustomSvg(
                    svgPath: AppImagesPaths.deleteIcon,
                    heightFactor: iconSize,
                  ),
                ),

              //
            ],
          ),
        ),
        const CustomSpacer(heightFactor: customSpacerHeightFactor2),
        if (((Platform.isIOS && !AuthService().isUserFree) ||
                (Platform.isAndroid)) &&
            meeting.recordingLink.isNotEmpty)
          LockingWidget(
            isLocked: AuthService().isUserFree,
            child: CustomButton(
              buttonType: ButtonType.elevatedButtonWithIcon,
              onPressed: () async =>
                  await controller.onPreviewRecording(meeting.recordingLink),
              elevation: elevation,
              icon: Icon(
                Icons.ondemand_video_rounded,
                size: iconSize.hf,
              ),
              textOverflow: textOverFlow,
              label: recordingLabel,
              height: recordingButtonHeight,
              width: recordingWidth,
              textStyle: recordingTextStyle,
              maxLines: maxLines,
            ),
          ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
