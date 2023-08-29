import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/design_utils.dart';
import '../core/utils/localization_service.dart';
import '../data/enums/widget_type.dart';
import 'app_colors.dart';
import 'app_theme.dart';

class AppTextTheme {
  //!=============================== Constructor ===============================
  static final AppTextTheme _singleton = AppTextTheme._internal();
  factory AppTextTheme() {
    return _singleton;
  }
  AppTextTheme._internal();
  //!===========================================================================

  static TextTheme getTextTheme([String? mainFontFamilyy]) {
    var mainFontFamily =
        mainFontFamilyy ?? LocalizationService.appLanguage.mainFontFamily;

    return TextTheme(
      /// Extremely large text.
      displayLarge: GoogleFonts.getFont(
        mainFontFamily,
        // Light
        fontWeight: FontWeight.w300,
        fontSize: 96.0,
        letterSpacing: -1.5,
        color: AppColors.black,
      ),

      /// Very, very large text.
      displayMedium: GoogleFonts.getFont(
        mainFontFamily,
        // Light
        fontWeight: FontWeight.w300,
        fontSize: 60.0,
        letterSpacing: -0.5,
        color: AppColors.black,
      ),

      /// Very large text.
      displaySmall: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 48.0,
        letterSpacing: 0,
        color: AppColors.black,
      ),

      /// Large text.
      headlineMedium: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 34,
        letterSpacing: 0.25,
        color: AppColors.black,
      ),

      /// Used for large text in dialogs (e.g., the month and year
      /// in the dialog shown by [showDatePicker]).
      headlineSmall: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
        letterSpacing: 0,
        color: AppColors.black,
      ),

      /// Used for the primary text in app bars and dialogs
      /// (e.g., AppBar.title and AlertDialog.title).
      titleLarge: GoogleFonts.getFont(
        mainFontFamily,
        // Medium
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
        letterSpacing: 0.15,
        color: AppColors.black,
      ),

      /// Used for the primary text in [lists]
      titleMedium: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        letterSpacing: 0.15,
        color: AppColors.black,
      ),

      /// For medium emphasis text that's a little smaller than [subtitle1].
      titleSmall: GoogleFonts.getFont(
        mainFontFamily,
        // Medium
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        letterSpacing: 0.1,
        color: AppColors.black,
      ),

      /// Used for emphasizing text that would otherwise be [bodyText2]
      bodyLarge: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        letterSpacing: 0.5,
        color: AppColors.black,
      ),

      /// The default text style for:
      /// [Material]
      /// [ListTile: Trailing]
      /// [Normal Text]
      bodyMedium: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        letterSpacing: 0.25,
        color: AppColors.black,
      ),

      /// Used for text on [ElevatedButton], [TextButton] and [OutlinedButton].
      labelLarge: GoogleFonts.getFont(
        mainFontFamily,
        // Medium
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        letterSpacing: 1.25,
        color: AppColors.white,
      ),

      /// Used for auxiliary text associated with [images]
      bodySmall: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        letterSpacing: 0.4,
        color: AppColors.grey,
      ),

      /// The smallest style
      labelSmall: GoogleFonts.getFont(
        mainFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: 10.0,
        letterSpacing: 1.5,
        color: AppColors.black,
      ),
    );
  }

  //!===========================================================================
  /// textStyle for [Text] at [Auth View]
  static TextStyle? get authTextStyle => getTextTheme().titleLarge?.copyWith(
        color: AppTheme.appTheme.primaryColor,
        fontWeight: FontWeight.bold,
      );

  //!===========================================================================
  /// textStyle for [Text] at [Auth View]
  static TextStyle? get boldHeadline5 => getTextTheme().headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );
  //!===========================================================================
  /// textStyle for [Text] at [Auth View]
  static TextStyle? get semiBoldHeadline5 =>
      getTextTheme().headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1,
          );
  //!===========================================================================
  static TextStyle? get italicCaption => getTextTheme().bodySmall?.copyWith(
        fontStyle: FontStyle.italic,
      );
  //!===========================================================================
  static TextStyle? get errorTextStyle => getTextTheme().bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.hazardColor,
      );
  //!===========================================================================
  /// textStyle for [Title Text] at [Middle Screen]
  static TextStyle? get titleTextStyle => getTextTheme().titleLarge?.copyWith(
        color: AppTheme.appTheme.primaryColor,
        fontWeight: FontWeight.w500,
      );
  //!===========================================================================
  /// textStyle for [Title Text] at [Middle Screen]
  static TextStyle? get middleScreenTitleTextStyle =>
      getTextTheme().titleLarge?.copyWith(
            color: AppTheme.appTheme.primaryColor,
            fontWeight: FontWeight.w600,
          );
  //!===========================================================================
  /// textStyle for [Button] at [Middle Screen]
  static TextStyle? get middleScreenButtonTextStyle =>
      getTextTheme().labelLarge?.copyWith(
            fontSize: 16.0,
          );
  //!===========================================================================
  static TextStyle? get boldPrimaryBodyText1 =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          );
  //!===========================================================================
  static TextStyle? get boldWhite15BodyText1 =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          );
  //!===========================================================================
  static TextStyle? get boldWhite14BodyText1 =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          );
  //!===========================================================================
  static TextStyle? bodyText1BoldGrey() =>
      AppTheme.appTheme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.grey,
      );
  //!===========================================================================

  static TextStyle? get boldPrimaryHeadline6 =>
      getTextTheme().titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          );
  //!===========================================================================
  static TextStyle? get boldPrimary800 => getTextTheme().bodyLarge?.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w800,
        fontFamily: LocalizationService.appLanguage.mainFontFamily,
      );
  //!===========================================================================

  static TextStyle? get packagesTitleStyle =>
      getTextTheme().titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontFamily: LocalizationService.appLanguage.mainFontFamily,
          );
  //!===========================================================================
  static TextStyle? get boldWhite18ItalicHeadline6 =>
      getTextTheme().titleLarge?.copyWith(
            fontSize: 18.0,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontStyle: FontStyle.italic,
          );

  //!===========================================================================
  static TextStyle? get boldWhite16headline6 =>
      getTextTheme().titleLarge?.copyWith(
            fontSize: 16.5,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          );

  //!===========================================================================
  /// textStyle for [Text] at [TextField]
  static TextStyle? get boldWhiteOverline =>
      getTextTheme().labelSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          );
  //!===========================================================================
  /// textStyle for [Text] at [TextField]
  static TextStyle? get textFormFieldStyle =>
      getTextTheme().labelSmall?.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          );
  //!===========================================================================

  static TextStyle? get boldSecodaryBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          );
  //!===========================================================================

  static TextStyle? get boardingSkipText => getTextTheme().bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryColor,
        decoration: TextDecoration.underline,
      );
  //!===========================================================================
  /// textStyle for [Text] at [TextField]
  static TextStyle? get contactFabTextStyle =>
      getTextTheme().labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          );
  //!===========================================================================
  /// textStyle for [Text] at [CircleAvatar]
  static TextStyle? get circleAvatarTextStyle =>
      getTextTheme().bodySmall?.copyWith(
            color: AppColors.white,
          );

  //!===========================================================================
  /// Highlighted textStyle for [bodyText1] at [TextFormField]
  static TextStyle? get highlightedTextFieldStyle =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppTheme.appTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 11.0,
          );
  //!===========================================================================
  /// Highlighted textStyle for bigger [bodyText1] at [TextFormField]
  static TextStyle? get bigHighlightedTextFieldStyle =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppTheme.appTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          );
  //!===========================================================================
  /// textStyle for bigger [Highlighted] at [TextFormField]
  static TextStyle? get bigHighlightedBodyText1 =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppTheme.appTheme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          );
  //!===========================================================================
  /// textStyle for bigger [Highlighted] at [TextFormField]
  static TextStyle? get boldPrimaryBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            color: AppTheme.appTheme.primaryColor,
            fontWeight: FontWeight.bold,
          );
  //!===========================================================================
  /// textStyle for big bold [headline4]
  static TextStyle? get boldHeadline4 =>
      getTextTheme().headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          );
  //!===========================================================================
  /// textStyle for  bold-red  [bodyText1]
  static TextStyle? get boldRedBodyText1 => getTextTheme().bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.errorColor,
      );
  //!===========================================================================
  /// textStyle for light [bodyText2]
  static TextStyle? get lightBodyText2 => getTextTheme().bodyMedium?.copyWith(
        color: AppColors.lightBlack,
      );

  //!===========================================================================
  /// textStyle for red-light with line through [Caption]
  static TextStyle? get discountedPriceTextStyle =>
      getTextTheme().bodySmall?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: AppColors.errorColor,
          );

  //!===========================================================================
  /// textStyle for bold [bodyText2]
  static TextStyle? get boldBodyText2 => getTextTheme().bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      );
  //!===========================================================================
  /// textStyle for bold [bodyText2]
  static TextStyle? get boldBodyText1 => getTextTheme().bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      );
  //!===========================================================================
  /// textStyle for bold [bodyText2]
  static TextStyle? get w300ItalicBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
          );

  //!===========================================================================
  /// textStyle for red [bodyText2]
  static TextStyle? get dangerBodyText2 => getTextTheme().bodyMedium?.copyWith(
        color: AppColors.hazardColor,
        fontWeight: FontWeight.bold,
      );
  //!===========================================================================
  /// textStyle for green-bold [bodyText2]
  static TextStyle? get greenBoldBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.bold,
          );
  //!===========================================================================
  /// textStyle for green-bold [headline6]
  static TextStyle? get boldHeadline6 => getTextTheme().titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      );
  //!===========================================================================
  /// textStyle for very small [bodyText2]
  static TextStyle? get smallBodyText2 => getTextTheme().bodyMedium?.copyWith(
        fontSize: 12.0,
      );
  //!===========================================================================
  /// textStyle for very small [bodyText2]
  static TextStyle? get smallPrimaryBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            fontSize: 12.0,
            color: AppColors.primaryColor,
          );
  //!===========================================================================
  static TextStyle? get noSearchResultTextStyle =>
      getTextTheme().titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.errorColor,
          );
  //!===========================================================================
  static TextStyle? get bold500BodyText1 => getTextTheme().bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
      );
  //!===========================================================================
  static TextStyle? get bold500BigText1 => getTextTheme()
      .bodyLarge
      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22);
  //!===========================================================================
  /// textStyle for very small [bodyText2]
  static TextStyle? get smallLightBodyText2 =>
      getTextTheme().bodyMedium?.copyWith(
            fontSize: 11.0,
            color: AppColors.packageFeatureListTileColor,
          );
  //!===========================================================================
  /// textStyle for Package Feature Tile
  static TextStyle? get packageFeatureListTileTextSyle =>
      getTextTheme().bodyMedium?.copyWith(
            fontSize: 10.0,
            color: AppColors.packageFeatureListTileColor,
          );
  //!===========================================================================
  /// textStyle for [PageTitle] text
  static TextStyle? bodyText2({
    double fontSize = 14.0,
    double? lineSpacing,
    Color? color,
    FontWeight? fontWeight,
  }) =>
      getTextTheme().bodyMedium?.copyWith(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: lineSpacing,
          );

  //!===========================================================================
  static TextStyle? get boldWhiteBodyText1 =>
      getTextTheme().bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          );
  //!===========================================================================
  static TextStyle? get body500 => getTextTheme().bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      );
  //!===========================================================================

  /// textstyle for any [TextButton]
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          // 'Primary' sets the color of the button, therefore the 'TEXT' init SMH.
          // and it also sets the color of the icon within it.
          foregroundColor: AppColors.primaryColor,
          textStyle: GoogleFonts.getFont(
            LocalizationService.appLanguage.mainFontFamily,
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          alignment: AlignmentDirectional.center,
          maximumSize: DesignUtils.buttonSize,
          shape: DesignUtils.getRoundedRectangleBorder(
              widgetType: UIWidgetType.button),
        ),
      );
  //!===========================================================================
  /// textstyle for any [OutlinedButton]
  static OutlinedButtonThemeData outlinedButtonButtonTheme([Color? color]) =>
      OutlinedButtonThemeData(
        style: outlinedButtonStyle(color),
      );

//!===========================================================================
  static ButtonStyle outlinedButtonStyle([Color? color, double? borderWidth]) =>
      TextButton.styleFrom(
        // 'Primary' sets the color of the button, therefore the 'TEXT' init SMH.
        // and it also sets the color of the icon within it.

        // use [AppColors] and not [AppTextTheme] as the
        // [AppTextTheme] is still being created at this point
        foregroundColor: color ?? AppColors.primaryColor,
        textStyle: GoogleFonts.getFont(
          LocalizationService.appLanguage.mainFontFamily,
          color: color ?? AppColors.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0.0,
        side: BorderSide(
          color: color ?? AppColors.primaryColor,
          width: borderWidth ?? 1.5,
        ),
        maximumSize: DesignUtils.buttonSize,

        shape: DesignUtils.getRoundedRectangleBorder(
            widgetType: UIWidgetType.button),
      );
  //!===========================================================================
  /// textstyle for any [Elevated/Filled TextButton]
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          // 'Primary' sets the color of the button, therefore the 'TEXT'
          // init SMH. and it also sets the color of the icon within it.
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.secondaryColor,
          textStyle: GoogleFonts.getFont(
            LocalizationService.appLanguage.mainFontFamily,
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          elevation: 9.0,
          alignment: AlignmentDirectional.center,
          maximumSize: DesignUtils.buttonSize,
          shape: DesignUtils.getRoundedRectangleBorder(
              widgetType: UIWidgetType.button),
        ),
      );

  //!===========================================================================

  static ButtonStyle? get enterprisePackageButtonStyle =>
      elevatedButtonTheme.style?.copyWith(
        backgroundColor: MaterialStateProperty.all(AppColors.black),
        textStyle: MaterialStateProperty.all(
          getTextTheme().labelLarge,
        ),
      );

  //!===========================================================================

  static ButtonStyle? get premiumPackageButtonStyle => TextButton.styleFrom(
        // 'Primary' sets the color of the button, therefore the 'TEXT'
        // init SMH. and it also sets the color of the icon within it.
        foregroundColor: AppColors.black, backgroundColor: AppColors.white,
        textStyle: getTextTheme().labelLarge?.copyWith(color: AppColors.black),
        elevation: 9.0,
        shape: DesignUtils.getRoundedRectangleBorder(radius: 8.0),
      );
  //!==================================================
  /// textstyle for any [Elevated/Filled TextButton]
  static final logoutButtonStyle = elevatedButtonTheme.style?.copyWith(
    elevation: MaterialStateProperty.all<double>(8.0),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      AppColors.errorColor,
    ),
  );
  //!===========================================================================
  //!===========================================================================
}
