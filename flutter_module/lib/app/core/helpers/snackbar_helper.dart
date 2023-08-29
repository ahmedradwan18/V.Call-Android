import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../data/enums/button_type.dart';
import '../../data/enums/snack_bar_type.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';
import '../../themes/app_theme.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/text/custom_text.dart';
import '../utils/logging_service.dart';

class SnackBarHelper {
  //!=============================== Constructor ===============================
  static final SnackBarHelper _singleton = SnackBarHelper._internal();

  factory SnackBarHelper() {
    return _singleton;
  }

  SnackBarHelper._internal();
  //!================================= Methods =================================
  static void showSnackBar({
    required String message,
    required SnackBarType type,
    String? errorCode,
    String mainButtonText = 'undo',
    bool showMainButton = false,
    VoidCallback? onTap,
    double iconSizeFactor = (0.07),
    double borderRadius = 12.0,
    double horizontalMarginFactor = 0.0402,
    double verticalPaddingFactor = 0.017,
    Color mainButtonColor = AppColors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    try {
      // dismiss the current snackbar
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.rawSnackbar(
        // to have a space between the text and flashing icon.
        backgroundColor: _getSnackBarColor(type),
        messageText: CustomText(
          message,
          style: AppTextTheme.boldWhite14BodyText1,
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
        duration: duration,
        borderRadius: borderRadius,
        // if I add padding here, the icon does not pulse
        icon: errorCode == null
            ? Padding(
                padding: EdgeInsetsDirectional.only(
                  start: (0.035).wf,
                ),
                child: Icon(
                  _getSnackBarIcon(type),
                  size: (iconSizeFactor).wf,
                  color: AppColors.white,
                ),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: (0.03).wf),
                  child: CustomText(
                    errorCode,
                    style: AppTextTheme.circleAvatarTextStyle,
                    maxLines: 1,
                  ),
                ),
              ),
        reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        dismissDirection: Platform.isAndroid
            ? DismissDirection.horizontal
            : DismissDirection.vertical,
        margin: EdgeInsets.symmetric(
          horizontal: (horizontalMarginFactor).wf,
          vertical: (verticalPaddingFactor).hf,
        ),
        shouldIconPulse: true,
        mainButton: !showMainButton
            ? null
            : CustomButton(
                buttonType: ButtonType.textButton,
                label: mainButtonText.tr,
                onPressed: onTap,
                width: (0.14).wf,
                buttonStyle: AppTheme.appTheme.textButtonTheme.style?.copyWith(
                  foregroundColor: MaterialStateProperty.all(mainButtonColor),
                ),
              ),
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:showSnackBar -- Helpers.dart',
        e,
        StackTrace.current,
      );
    }
  }

  //!==================================================
  static Color _getSnackBarColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return AppColors.errorColor;
      case SnackBarType.action:
        return AppColors.snackBarActionColor;
      case SnackBarType.information:
        return AppColors.snackBarInformationColor;

      default:
        return AppColors.snackBarInformationColor;
    }
  }

  //!==================================================
  static IconData _getSnackBarIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return FontAwesomeIcons.circleRadiation;
      case SnackBarType.action:
        return FontAwesomeIcons.gripfire;
      case SnackBarType.information:
        return FontAwesomeIcons.watchmanMonitoring;

      default:
        return FontAwesomeIcons.watchmanMonitoring;
    }
  }

  //!===========================================================================
}
