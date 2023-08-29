import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/utils/design_utils.dart';
import '../../../core/values/app_images_paths.dart';
import '../../../data/enums/button_type.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/custom_spacer.dart';
import '../../../widgets/custom_svg.dart';

class RoomLinks extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final String moderatorLink;
  final String attendeeLink;
  final String roomTitle;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const RoomLinks({
    Key? key,
    required this.moderatorLink,
    required this.attendeeLink,
    required this.roomTitle,
  }) : super(key: key);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final moderatorLabel = 'moderator_url'.tr;
    final attendeeLabel = 'attendee_url'.tr;

    final attendeeLinkCopyText = Helpers.getLinkSharingMessage(
      link: attendeeLink,
      role: 'viewer'.tr,
      roomTitle: roomTitle,
    );
    final moderatorLinkCopyText = Helpers.getLinkSharingMessage(
      link: moderatorLink,
      role: 'moderator'.tr,
      roomTitle: roomTitle,
    );

    final copyModeratorMessage = ('text_copied_to_clipboard'.tr).replaceFirst(
      'x',
      moderatorLabel,
    );
    final copyAttendeeMessage = ('text_copied_to_clipboard'.tr).replaceFirst(
      'x',
      attendeeLabel,
    );

    final buttonHeight = (0.035).hf;
    final buttonWidth = (0.4).wf;
    //*=========================================================================
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: CustomButton(
            shape: DesignUtils.getRoundedRectangleBorder(radius: 8),
            buttonType: ButtonType.elevatedButtonWithIcon,
            icon: const CustomSvg(
              svgPath: AppImagesPaths.moderatorIcon,
              heightFactor: 0.025,
            ),
            onPressed: () async => await Helpers.copyTextToClipboard(
              moderatorLinkCopyText,
              message: copyModeratorMessage,
            ),
            label: moderatorLabel,
            height: buttonHeight,
            width: buttonWidth,
            buttonStyle: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: AppColors.primaryColor,
              shadowColor: Colors.transparent,
            ),
          ),
        ),
        const CustomSpacer(
          widthFactor: 0.015,
        ),
        Flexible(
          child: CustomButton(
            shape: DesignUtils.getRoundedRectangleBorder(radius: 8),
            buttonType: ButtonType.elevatedButtonWithIcon,
            onPressed: () async => await Helpers.copyTextToClipboard(
              attendeeLinkCopyText,
              message: copyAttendeeMessage,
            ),
            icon: const CustomSvg(
              svgPath: AppImagesPaths.attendeeIcon,
              // heightFactor: 0.025,
              widthFactor: 0.06,
            ),
            label: attendeeLabel,
            buttonStyle: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: AppColors.secondaryColor,
              shadowColor: Colors.transparent,
            ),
            height: buttonHeight,
            width: buttonWidth,
          ),
        ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
