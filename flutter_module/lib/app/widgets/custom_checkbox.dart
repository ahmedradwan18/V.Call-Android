import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/text/custom_text.dart';

import '../core/values/app_constants.dart';
import '../themes/app_colors.dart';
import 'custom_spacer.dart';

class CustomCheckBox extends StatelessWidget {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final void Function(bool?) onChanged;
  final bool isSelected;
  final TextStyle? textStyle;
  final String label;
  final Widget? leading;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const CustomCheckBox({
    required this.onChanged,
    Key? key,
    this.isSelected = false,
    this.textStyle,
    required this.label,
    this.leading,
  }) : super(key: key);
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    bool isSelected = this.isSelected;
    final textStyle = this.textStyle ?? Theme.of(context).textTheme.bodyMedium!;
    //*=========================================================================
    return InkWell(
      onTap: () => onChanged(
        !isSelected,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          if (leading != null) const CustomSpacer(widthFactor: 0.017),
          Flexible(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: AnimatedDefaultTextStyle(
                style: textStyle.copyWith(
                  color: (isSelected) ? null : AppColors.grey,
                ),
                curve: AppConstants.navigationCurve,
                duration: AppConstants.shortDuration,
                child: CustomText(
                  label,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          if (leading != null)
            const CustomSpacer(
              widthFactor: 0.08,
            ),
          Transform.scale(
            scale: 0.7,
            child: Checkbox(
              value: (isSelected),
              onChanged: (bool? newVal) {
                isSelected = newVal!;
                onChanged(
                  newVal,
                );
              },
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              checkColor: AppColors.white,
              fillColor: MaterialStateProperty.all(AppColors.green),
              side: const BorderSide(
                color: AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //*===========================================================================
  //*===========================================================================
}
