import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/design_utils.dart';
import '../core/utils/localization_service.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  //!=============================== Constructor ===============================
  static final AppTheme _singleton = AppTheme._internal();
  factory AppTheme() {
    return _singleton;
  }
  AppTheme._internal();
  //!============================== Properties =================================
  static ThemeData _lightTheme = ThemeData.light();
  static final ThemeData _darkTheme = ThemeData.dark();

  //!============================ Setters/Getters ==============================
  static ThemeData get appTheme => Get.isDarkMode ? _darkTheme : _lightTheme;

  static ThemeData get disabledSplashAppTheme => appTheme.copyWith(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
      );

  //!=============================== Methods ===================================
  static void updateAppTheme() {
    _updateLightTheme();
    _updateDarkTheme();
  }

  //!==================================================
  static void _updateDarkTheme() {}
  //!==================================================
  static void _updateLightTheme() {
    // decide on the font based on language
    // use the one at [Globals] and not [Get.locale] as that one handles the
    // case of null at the very beginning
    final mainFontFamily = LocalizationService.appLanguage.mainFontFamily;
    const Color primaryColor = AppColors.primaryColor;

    // return the light theme.
    _lightTheme = ThemeData.light().copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColor,
      primaryColorDark: primaryColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      textTheme: AppTextTheme.getTextTheme(mainFontFamily),
      primaryTextTheme: AppTextTheme.getTextTheme(mainFontFamily),
      textButtonTheme: AppTextTheme.textButtonTheme,
      elevatedButtonTheme: AppTextTheme.elevatedButtonTheme,
      outlinedButtonTheme: AppTextTheme.outlinedButtonButtonTheme(
        primaryColor,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),

      shadowColor: AppColors.shadowColor,
      timePickerTheme: TimePickerThemeData(
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: DesignUtils.getBorderRadius(),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: AppTextTheme.boldPrimaryBodyText1,
        labelColor: primaryColor,
        unselectedLabelStyle: AppTextTheme.lightBodyText2,
        unselectedLabelColor: AppColors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.secondaryColor,
            width: 4.5,
          ),
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: primaryColor,
        size: DesignUtils.defaultIconSize,
      ),
      // the [Icon] widget's color throughout the application.
      iconTheme: IconThemeData(
        color: primaryColor,
        size: DesignUtils.defaultIconSize,
      ),
      colorScheme: const ColorScheme.light(
        // changes the color of the active [Step]
        primary: primaryColor,
        // change the color of the inactive [Step] to a light version
        // of the provided [Color]
        onSurface: primaryColor,
        onSecondary: AppColors.secondaryColor,
        secondary: AppColors.secondaryColor,
      ).copyWith(
        primary: MaterialColor(
          primaryColor.value,
          const {
            50: primaryColor,
            100: primaryColor,
            200: primaryColor,
            300: primaryColor,
            400: primaryColor,
            500: primaryColor,
            600: primaryColor,
            700: primaryColor,
            800: primaryColor,
            900: primaryColor,
          },
        ),
        secondary: AppColors.secondaryColor,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: DesignUtils.getBorderRadius(),
        ),
      ),
    );
  }

  //!==================================================
  static ThemeData iconTheme({double? size, Color? color}) => appTheme.copyWith(
        iconTheme: appTheme.iconTheme.copyWith(
          size: size,
          color: color,
        ),
      );
  //!==================================================
  static ButtonStyle outlinedButtonStyle({
    required Color color,
    double borderWidth = 1.0,
  }) =>
      OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(
          color: color,
          width: borderWidth,
        ),
      );
  //*==================================================
  static ButtonStyle elevatedButtonStyle({
    required Color color,
    double borderWidth = 1.0,
  }) =>
      ElevatedButton.styleFrom(
        backgroundColor: color,
        side: BorderSide(
          color: color,
          width: borderWidth,
        ),
      );
  //*==================================================
  static ButtonStyle? get getDisabledElevatedButtonStyle =>
      ElevatedButton.styleFrom().copyWith(
        backgroundColor: MaterialStateProperty.all(AppColors.grey),
        shadowColor: MaterialStateProperty.all(AppColors.transparent),
        // to disable splash.
        overlayColor: MaterialStateProperty.all(AppColors.transparent),

        foregroundColor: MaterialStateProperty.all(AppColors.white),
        elevation: MaterialStateProperty.all(
          1.0,
        ),

        enableFeedback: false,
        splashFactory: null,
      );
  //*==================================================
  static ButtonStyle? get getDisabledOutlinedButtonStyle =>
      OutlinedButton.styleFrom().copyWith(
        backgroundColor: MaterialStateProperty.all(AppColors.grey),
        shadowColor: MaterialStateProperty.all(AppColors.transparent),
        // to disable splash.
        overlayColor: MaterialStateProperty.all(AppColors.transparent),

        foregroundColor: MaterialStateProperty.all(AppColors.white),
        elevation: MaterialStateProperty.all(
          1.0,
        ),

        enableFeedback: false,
        splashFactory: null,
      );

  //*==================================================
  static ButtonStyle? get getDisabledTextButtonStyle => TextButton.styleFrom();

  //!===========================================================================
  //!===========================================================================
}
