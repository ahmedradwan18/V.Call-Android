import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';

import '../../core/utils/design_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';
import '../buttons/two_buttons.dart';
import '../custom_spacer.dart';
import '../text/custom_text.dart';

class DeletePrompt extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final String title;
  final String itemType;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const DeletePrompt({
    super.key,
    required this.title,
    required this.itemType,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: DesignUtils.getRoundedRectangleBorder(radius: 29.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* Header

          Flexible(
            child: CustomText(
              'are_you_sure'.tr,
              style: AppTextTheme.boldBodyText1,
            ),
          ),
          const CustomSpacer(heightFactor: 0.01),

          //* Second Header
          Flexible(
            child: CustomText(
              '${'delete_alert'.tr}\r${itemType.tr}',
            ),
          ),

          //* Meeting Title
          const CustomSpacer(heightFactor: 0.025),
          Container(
            decoration: BoxDecoration(
              borderRadius: DesignUtils.getBorderRadius(radius: 11),
              color: AppColors.lightSecondaryColor,
            ),
            height: (0.05).hf,
            width: (0.4).wf,
            alignment: AlignmentDirectional.center,
            child: CustomText(
              title,
              style: AppTextTheme.boldSecodaryBodyText2,
              maxLines: 3,
            ),
          ),

          //* Deletion Icon

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: (0.035).hf,
            ),
            child: Icon(
              FontAwesomeIcons.solidTrashCan,
              size: (0.085).hf,
              color: AppColors.dangerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (0.06).wf,
            ),
            child: TwoButtons(
              applyButtonLabel: '${'delete'.tr}\r${itemType.tr}',
              cancelButtonLabel: 'cancel'.tr,
              buttonHeight: (0.05).hf,
              applyButtonHandler: () => Get.back(result: true),
              cancelButtonHandler: () => Get.back(result: false),
              buttonWidth: (0.4).wf,
              spacerWidth: (0.05).wf,
            ),
          ),
        ],
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
