import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/helpers/helpers.dart';
import '../../../core/values/app_constants.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';
import 'copy_button.dart';

class CopyWidget extends StatelessWidget {
  //*================================ Parameters ===============================
  final String meetingTitle;
  final String meetingLink;
  final String meetingID;
  final String? password;
  final bool isVisible;
  //*================================ Constructor ==============================
  const CopyWidget({
    Key? key,
    required this.meetingLink,
    required this.isVisible,
    required this.meetingID,
    this.password,
    required this.meetingTitle,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Parameters =============================

    final copyLinkMessage = ('text_copied_to_clipboard'.tr).replaceAll(
      'x',
      'meeting_link'.tr,
    );
    final copyCodeMessage = ('text_copied_to_clipboard'.tr).replaceAll(
      'x',
      'meeting_code'.tr,
    );

    final meetingLinkCopyText = Helpers.getLinkSharingMessage(
      link: meetingLink,
      meetingID: meetingID,
      meetingTitle: meetingTitle,
      password: password,
    );

    final linkButtonText = 'copy_link'.tr;
    final codeButtonText = 'copy_code'.tr;
    const imageHeightFactor = 0.017;
    final buttonWidth = (0.33).wf;
    const animationCurve = Curves.easeOutExpo;
    const duration = AppConstants.subLongDuration;
    const customHeightSpacer = 0.01;
    //*=========================================================================
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.3,
      duration: duration,
      curve: animationCurve,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Copy meeting link
          Flexible(
            child: AnimatedScale(
              scale: isVisible ? 1 : 0.15,
              alignment: Alignment.bottomCenter,
              duration: duration,
              curve: animationCurve,
              child: AnimatedSlide(
                offset:
                    isVisible ? const Offset(0, 0) : const Offset(-0.4, 2.0),
                duration: duration,
                curve: animationCurve,
                child: CopyButton(
                  copyData: meetingLinkCopyText,
                  label: linkButtonText,
                  width: buttonWidth,
                  icon: const CustomSvg(
                    svgPath: AppImagesPaths.copyLinkSvgPath,
                    heightFactor: imageHeightFactor * 1.1,
                  ),
                  copyMessgage: copyLinkMessage,
                  buttonColor: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          const CustomSpacer(heightFactor: customHeightSpacer),
          //* Copy meeting ID/Code
          Flexible(
            child: AnimatedScale(
              scale: isVisible ? 1 : 0.3,
              alignment: Alignment.topCenter,
              duration: duration,
              curve: animationCurve,
              child: AnimatedSlide(
                offset:
                    isVisible ? const Offset(0, 0) : const Offset(-0.4, -2.0),
                duration: duration,
                curve: animationCurve,
                child: CopyButton(
                  copyData: meetingID,
                  label: codeButtonText,
                  width: buttonWidth,
                  icon: const CustomSvg(
                    svgPath: AppImagesPaths.copyCodeSvg,
                    heightFactor: imageHeightFactor,
                  ),
                  copyMessgage: copyCodeMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //*===========================================================================
}
