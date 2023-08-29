import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/design_utils.dart';
import '../../../core/utils/logging_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/animation/animated_slide_scale.dart';
import '../../../widgets/textfields/custom_text_field.dart';
import '../controllers/creation_controller.dart';
import 'time_picker_widget.dart';

class TimePicker extends GetView<CreationController> {
  //*================================ Properties ===============================

  //*================================ Constructor ==============================
  const TimePicker({Key? key}) : super(key: key);
  //*================================= Methods =================================
  Future<void> openTimePicker() async {
    try {
      await Get.generalDialog(
        barrierDismissible: true,
        // Required if I want the [BarrierDismissible] to be true
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            // use the provided animation, to animate the page into view.
            AnimatedSlideScaleWidget(
          animation: animation,
          startOffset: const Offset(1, 0),
          child: TimePickerWidget(controller.meetingTemplate.time),
        ),
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:openTimePicker -- time_picker.dart',
        e,
        StackTrace.current,
      );
      controller.editMeetingTemplate(
        inputTime: DateTimeUtils.getStringFromTime(
          DateTime.now().add(
            const Duration(minutes: 1),
          ),
        ),
      );
    }
  }

  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double iconSizeFactor = 0.023;
    //*=========================================================================

    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomTextField(
        onTap: openTimePicker,

        hintText: '',
        textStyle: AppTextTheme.highlightedTextFieldStyle,
        isReadOnly: true,
        // change will happen from [TimePickerWidget]
        onChangedHandler: (_) {},
        // to assign the value to it's text, only way to change text in
        // textField other than typing it manually
        textEditingController: controller.meetingTimeTextFieldController,
        onValidateHandler: controller.validateMeetingTime,
        showAlwaysVisibleSuffixWidget: true,
        showSuffixWidget: false,
        alwaysVisibleSuffixWidget: Padding(
          padding: EdgeInsetsDirectional.only(
            end: DesignUtils.getDesignFactor(0.013),
          ),
          child: Icon(
            FontAwesomeIcons.clock,
            size: DesignUtils.getDesignFactor(iconSizeFactor),
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
  //*=========================================================================
}
