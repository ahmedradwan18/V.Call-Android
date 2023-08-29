import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/text/custom_text.dart';
import 'package:flutter_module/app/widgets/text/fitted_text.dart';
import 'package:get/get.dart';
import '../core/utils/design_utils.dart';
import '../core/utils/localization_service.dart';
import '../core/values/app_constants.dart';
import '../data/typedefs/app_typedefs.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_theme.dart';
import '../themes/app_theme.dart';

class SettingSwitchTile extends StatelessWidget {
  //*=============================== Properties ================================
  /// dynamic as I don't know the structure of the [Switch Class] for it to
  /// be fully Modular, I just require the class to have a [Value] and [Title]
  final dynamic setting;
  final OnToggleMeetingSetting onToggleSetting;

  //*=============================== Constructor ===============================
  const SettingSwitchTile({
    required this.onToggleSetting,
    required this.setting,
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    var horizontalPadding = 6.0;
    //*=========================================================================
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: DesignUtils.getBorderRadius(),
      ),
      activeColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.grey,
      title: Align(
        alignment: Alignment.centerLeft,
        child: FittedText(
          LocalizationService.appLanguage == AppConstants.english
              ? setting.titleEn
              : setting.titleAr,
          textStyle: AppTheme.appTheme.textTheme.bodyMedium,
          maxLines: 3,
        ),
      ),
      value: setting.isOn.value,
      onChanged: !(setting.isEditable) ? null : (_) => onToggleSetting(setting),
      subtitle: (setting.isEditable)
          ? CustomText(
              LocalizationService.appLanguage == AppConstants.english
                  ? setting.descriptionEn!
                  : setting.descriptionAr!,
              maxLines: 2,
            )
          : FittedText(
              'go_pro_to_enable'.tr,
              alignment: AlignmentDirectional.centerStart,
              textStyle: AppTextTheme.bigHighlightedTextFieldStyle,
            ),
    );
  }
  //*===========================================================================
}
