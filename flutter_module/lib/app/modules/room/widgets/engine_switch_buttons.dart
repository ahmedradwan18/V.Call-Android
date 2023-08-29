import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/enums/meeting_type.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_svg.dart';

class EngineSwitchButtons extends StatelessWidget {
  const EngineSwitchButtons({
    super.key,
    required this.isMeet,
    required this.onMeetPressed,
    required this.onClassRoomPressed,
    this.buttonWidth,
  });

  final bool isMeet;
  final VoidCallback onClassRoomPressed;
  final VoidCallback onMeetPressed;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    final isMeet = (this.isMeet).obs;
    const iconSizeFactor = 0.02;
    final buttonHeight = (0.04).hf;
    final buttonWidth = this.buttonWidth ?? (0.42).wf;
    return Obx(
      () => Row(
        children: [
          CustomButton(
            onPressed: onClassRoomPressed,
            backgroundColor: isMeet.value ? null : AppColors.primaryColor,
            label: MeetingType.classroom.name.tr,
            buttonType: isMeet.value
                ? ButtonType.outlinedButtonWithIcon
                : ButtonType.elevatedButtonWithIcon,
            icon: CustomSvg(
              svgPath: AppImagesPaths.classroomIcon,
              heightFactor: iconSizeFactor,
              color: isMeet.value ? AppColors.primaryColor : null,
            ),
            buttonStyle: isMeet.value
                ? OutlinedButton.styleFrom(
                    side: const BorderSide(width: 0.5, color: AppColors.grey),
                  )
                : ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: AppColors.primaryColor,
                    shadowColor: Colors.transparent,
                  ),
            height: buttonHeight,
            width: buttonWidth,
          ),
          const Spacer(),
          CustomButton(
            onPressed: onMeetPressed,
            label: MeetingType.meet.name.tr,
            buttonType: isMeet.value
                ? ButtonType.elevatedButtonWithIcon
                : ButtonType.outlinedButtonWithIcon,
            icon: CustomSvg(
              svgPath: AppImagesPaths.meetIcon,
              heightFactor: iconSizeFactor,
              color: isMeet.value ? null : AppColors.primaryColor,
            ),
            buttonStyle: isMeet.value
                ? ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: AppColors.primaryColor,
                    shadowColor: Colors.transparent,
                  )
                : OutlinedButton.styleFrom(
                    side: const BorderSide(width: 0.5, color: AppColors.grey),
                  ),
            height: buttonHeight,
            backgroundColor: isMeet.value ? AppColors.primaryColor : null,
            width: buttonWidth,
          )
        ],
      ),
    );
  }
}
