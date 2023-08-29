import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_theme.dart';
import '../controllers/creation_controller.dart';

class TimePickerWidget extends GetView<CreationController> {
  //*================================ Properties ===============================
  final String pickedTime;
  //*================================ Constructor ==============================
  const TimePickerWidget(this.pickedTime, {Key? key}) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const cancelText = '';
    final okLabel = 'confirm'.tr;
    //*=========================================================================
    return showPicker(
      elevation: 4,
      // somehow I have to do this for it to work
      themeData: AppTheme.appTheme.copyWith(
        textTheme: AppTheme.appTheme.textTheme.copyWith(
          displayMedium: const TextStyle(
            fontSize: 15,
            color: AppColors.grey,
          ),
        ),
      ),
      accentColor: AppColors.primaryColor,
      blurredBackground: true,
      // The value when I open the [TimePicker]
      value: Time(
        hour: DateTimeUtils.getTimeOfDay(pickedTime).hour,
        minute: DateTimeUtils.getTimeOfDay(pickedTime).minute,
      ),
      // MUST PRESS [OKEY] TO FUNCTION
      onChange: (_) {},

      // NO min hour/minute, as It might be 5 o'clock today and I want
      // to scheduel a 3 O'clock tommorrow
      iosStylePicker: false,
      is24HrFormat: true,
      // MUST PRESS [OKEY] TO FUNCTION
      onChangeDateTime: (time) {
        controller.editMeetingTemplate(
          inputTime: DateTimeUtils.getStringFromTime(time),
        );
        // close the entire widget
        Get.back();
      },
      cancelText: cancelText,
      okText: okLabel,
    );
  }
  //*============================================================================
}
