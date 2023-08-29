import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/utils/design_utils.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../controllers/meetings_controller.dart';

class MeetingActions extends GetView<MeetingsController> {
  //*================================ Properties ===============================
  final dynamic meeting;
  final double? iconSizeFactor;
  //*================================ Constructor ==============================
  const MeetingActions(
    this.meeting, {
    Key? key,
    this.iconSizeFactor,
  }) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*============================== Parameters ===============================
    final buttonWidthFactor = (0.38).wf;
    final buttonHeightFactor = (0.0431).hf;
    const double topPaddingFactor = 0.01;

    //*================================ Methods ================================
    return Padding(
      padding: EdgeInsets.only(
        top: DesignUtils.getDesignFactor(topPaddingFactor),
      ),
      child: CustomButton(
        onPressed: () => controller.onRunMeeting(meeting),
        label: 'run_meeting'.tr,
        height: buttonHeightFactor,
        width: buttonWidthFactor,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
  //*===========================================================================
}
