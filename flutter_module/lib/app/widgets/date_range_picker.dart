import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../core/utils/design_utils.dart';
import '../themes/app_colors.dart';

class DateRangePicker extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final Function(Object?)? onSelectionChanged;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const DateRangePicker({
    super.key,
    this.onSelectionChanged,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final borderRadius = DesignUtils.getBorderRadius();
    //*=========================================================================
    return ClipRRect(
      borderRadius: borderRadius,
      child: SfDateRangePicker(
        onSubmit: onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        backgroundColor: AppColors.white,
        showNavigationArrow: true,
        showTodayButton: true,
        toggleDaySelection: true,
        showActionButtons: true,
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
