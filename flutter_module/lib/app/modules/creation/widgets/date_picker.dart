import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/design_utils.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_theme.dart';
import '../../../widgets/text/custom_text.dart';

class DatePicker extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================

  final String selectedDate;
  final Function()? onTap;
  final double? iconSize;
  final TextStyle? textStyle;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const DatePicker({
    Key? key,
    required this.selectedDate,
    this.onTap,
    this.iconSize,
    this.textStyle,
  }) : super(key: key);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.grey,
      borderRadius: BorderRadius.circular(10.0),
      child: InputDecorator(
        decoration: DesignUtils.getFormInputDecoration(
          showSuffixWidget: false,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomText(
                selectedDate,
                style: textStyle ?? AppTextTheme.highlightedTextFieldStyle,
              ),
            ),
            Icon(
              FontAwesomeIcons.calendarDays,
              color: Theme.of(context).primaryColor,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
