import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/utils/design_utils.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/button_type.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/buttons/animated_button.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';

import '../controllers/meetings_controller.dart';

class RunningMeetingActions extends GetView<MeetingsController> {
  //*================================ Properties ===============================
  final dynamic meeting;
  final double? iconSizeFactor;

  //*================================ Constructor ==============================
  const RunningMeetingActions({
    required this.meeting,
    this.iconSizeFactor,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*============================== Parameters ===============================
    const double topPaddingFactor = 0.01;
    const double sizedBoxWidth = 30.0;
    final joinButtonWidthFactor = (0.48).wf;
    final endButtonWidthFactor = (0.18).wf;
    final buttonHeightFactor = (0.0431).hf;
    final theme = Theme.of(context);
    //*================================ Methods ================================
    return Theme(
      data: theme.copyWith(
        iconTheme: theme.iconTheme.copyWith(
          size: iconSizeFactor?.hf,
        ),
      ),
      child: Padding(
        // only pad the of the [Actions]
        padding: EdgeInsets.only(
          top: DesignUtils.getDesignFactor(topPaddingFactor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => AnimatedButton(
                onPressed: () async =>
                    await controller.onJoinMeetingAsModerator(
                  meeting: meeting,
                ),
                isLoading: controller.shouldIgnorePointer &&
                    (controller.runningMeetingsIDList.first ==
                        meeting.meetingDataBaseID),
                label: 'join_meeting'.tr,
                buttonType: ButtonType.elevatedButtonWithIcon,
                backgroundColor: AppColors.primaryColor,
                width: joinButtonWidthFactor,
                height: buttonHeightFactor,
                icon: const Icon(FontAwesomeIcons.rightToBracket),
              ),
            ),
            const CustomSpacer(
              width: sizedBoxWidth,
            ),
            CustomButton(
              onPressed: () => controller.shouldEndMeeting(meeting),
              backgroundColor: AppColors.red400,
              width: endButtonWidthFactor,
              height: buttonHeightFactor,
              child: const CustomSvg(
                svgPath: AppImagesPaths.endMeeting,
                color: AppColors.white,
                heightFactor: 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
