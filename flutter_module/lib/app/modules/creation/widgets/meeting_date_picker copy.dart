import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/localization_service.dart';
import '../../../core/utils/logging_service.dart';
import '../../../themes/app_text_theme.dart';
import '../controllers/creation_controller.dart';
import 'date_picker.dart';

class MeetingDatePicker extends GetView<CreationController> {
  //*================================ Properties ===============================

  //*================================ Constructor ==============================
  const MeetingDatePicker({Key? key}) : super(key: key);
  //*================================= Methods =================================
  Future<void> openDatePicker({
    required BuildContext context,
    required int datePickerDaysInFuture,
  }) async {
    try {
      final initialDate = DateTimeUtils.getDateFromString(
        controller.meetingTemplate.date,
      );
      final currentDate = DateTime.now();
      var selectedDate = await showDatePicker(
        context: Get.context ?? context,
        // chosen date
        initialDate: initialDate,
        // today ..
        firstDate:
            !initialDate.isBefore(currentDate) ? currentDate : initialDate,
        lastDate: currentDate.add(
          Duration(days: datePickerDaysInFuture),
        ),
        locale: LocalizationService.appLanguage.locale,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          final theme = Theme.of(context);
          return Theme(
            data: theme.copyWith(
              textTheme: theme.textTheme.copyWith(
                headlineMedium: AppTextTheme.boldBodyText1?.copyWith(
                  fontSize: 25,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      // null = user dismissed / canceled the pop-up
      if (selectedDate != null) {
        controller.editMeetingTemplate(inputDate: selectedDate);
      }
    } catch (e) {
      LoggingService.error(
        'Error at Method:openDatePicker -- date_picker.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final iconSize = 0.023.hf;
    const int datePickerDaysInFuture = 3000;
    //*=========================================================================
    // Avoided [IconButton] for it's padding, SMH.
    return Obx(
      () => DatePicker(
        selectedDate: controller.meetingTemplate.date,
        iconSize: iconSize,
        onTap: () async => await openDatePicker(
          context: context,
          datePickerDaysInFuture: datePickerDaysInFuture,
        ),
      ),
    );
  }
  //*=========================================================================
}
