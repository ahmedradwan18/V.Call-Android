import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import '../../../widgets/text/custom_text.dart';

class MeetingCardInformation extends StatelessWidget {
  //*================================ Properties ===============================
  final dynamic meeting;
  //*================================ Constructor ==============================
  const MeetingCardInformation(this.meeting, {Key? key}) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerSmallHeightFactor = 0.01;
    const double customSpacerBigHeightFactor = 0.013;
    const int maxLines = 2;
    const int dateTimeMaxLines = 1;

    final titleTextStyle = AppTextTheme.boldPrimaryHeadline6?.copyWith(
      fontSize: 18.0,
    );
    final infoTextStyle = AppTextTheme.lightBodyText2;
    final meetingTime = DateTimeUtils.formatTime(meeting.meetingTime);
    final meetingDate = DateTimeUtils.formatDate(meeting.meetingDate);

    //*=========================================================================
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Title
        const CustomSpacer(heightFactor: customSpacerSmallHeightFactor),
        Padding(
          padding: EdgeInsetsDirectional.only(
            end: (0.05).wf,
          ),
          child: CustomText(
            meeting.meetingTitle,
            maxLines: maxLines,
            useTextOverflow: true,
            style: titleTextStyle,
          ),
        ),
        Row(
          children: [
            CustomSvg(
              svgPath: meeting.engineType == MeetingType.classroom
                  ? AppImagesPaths.classroomIcon
                  : AppImagesPaths.meetIcon,
              heightFactor: 0.015,
              color: AppColors.primaryColor,
            ),
            const CustomSpacer(
              widthFactor: 0.008,
            ),
            CustomText(
              meeting.engineType.name,
              style: AppTextTheme.smallPrimaryBodyText2,
            ),
          ],
        ),
        //* Date & Time
        const CustomSpacer(heightFactor: 0.017),
        CustomText(
          '$meetingDate - $meetingTime',
          maxLines: dateTimeMaxLines,
          style: infoTextStyle,
        ),

        //* Description
        const CustomSpacer(heightFactor: customSpacerBigHeightFactor),
        CustomText(
          meeting.roomTitle ?? 'room'.tr,
          maxLines: maxLines,
          useTextOverflow: true,
          style: infoTextStyle,
        ),
      ],
    );
  }
  //*===========================================================================
}
