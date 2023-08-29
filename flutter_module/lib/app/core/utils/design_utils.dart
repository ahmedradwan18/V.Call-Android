import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/route_manager.dart';

import '../../data/enums/widget_type.dart';
import '../../themes/app_colors.dart';

/// Will hold some code related to the UI throught the entire application
/// [Global] for [UI]
class DesignUtils {
  //*=============================== Constructor ===============================
  static final DesignUtils _singleton = DesignUtils._internal();
  factory DesignUtils() {
    return _singleton;
  }
  DesignUtils._internal();
  //*============================== Parameters =================================
  static const double defaultBorderRadiusValue = 7.0;
  static const double defaultTextFieldBorderRadiusValue = 12.0;
  static final double defaultFontAwesoneIconSize = (0.024).hf;
  static final double defaultIconSize = (0.03).hf;
  static final double accountViewHorizontalPadding = (0.075).wf;
  static final buttonSize = Size(
    (0.538).wf,
    (0.067).hf,
  );

  //*================================= Methods =================================
  static final List<BoxShadow> tabBoxShadow = [
    BoxShadow(
      color: AppColors.veryLightPrimaryColor,
      blurRadius: 1.5,
      spreadRadius: 1.5,
      blurStyle: BlurStyle.outer,
    ),
  ];
  //*==================================================
  static final giftCardLinearGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    // change the colors
    colors: <Color>[
      AppColors.promoCodeGradientColor,
      AppColors.promoCodeGradientColor,
      AppColors.promoCodeGradientColor,
      AppColors.promoCodeGradientColor,
      AppColors.promoCodeGradientColor,
      AppColors.white.withOpacity(0.5),
      AppColors.promoCodeGradientColor,
    ],
  );
  //*================================= Methods =================================
// to get the double value to be used in design as a percentage of device's
// aspect ratio .. height/width/padding
  static double getDesignFactor(double factor) {
    return Get.mediaQuery.orientation == Orientation.portrait
        ? Get.height * factor
        : Get.width * factor;
  }

  //*=================================================
  static BorderRadius getBorderRadius({
    double? radius,
    UIWidgetType? widgetType,
  }) =>
      BorderRadius.circular(
        radius ?? (widgetType?.radius ?? defaultBorderRadiusValue),
      );
  //*=================================================
  static RoundedRectangleBorder getRoundedRectangleBorder({
    double? radius,
    double borderWidth = 1,
    bool showBorder = false,
    Color borderColor = Colors.deepOrange,
    UIWidgetType? widgetType,
  }) {
    final finalRadius = radius ?? _getRadiusBasedOnWidgetType(widgetType);
    return RoundedRectangleBorder(
      borderRadius: getBorderRadius(radius: finalRadius),
      side: showBorder
          ? BorderSide(
              color: borderColor,
              width: borderWidth,
            )
          : BorderSide.none,
    );
  }

  //*=================================================
  static double _getRadiusBasedOnWidgetType(UIWidgetType? widgetType) {
    switch (widgetType) {
      case UIWidgetType.textField:
        return defaultTextFieldBorderRadiusValue;
      default:
        return defaultBorderRadiusValue;
    }
  }

  //*=================================================
  static OutlineInputBorder getOutlineInputBorder({
    UIWidgetType? widgetType,
    double? radius,
    Color borderColor = AppColors.primaryColor,
    double width = 1.0,
  }) =>
      OutlineInputBorder(
        borderRadius: getBorderRadius(
          widgetType: widgetType,
          radius: radius,
        ),
        borderSide: BorderSide(
          color: borderColor,
          width: width,
        ),
        // horizontal padding for the floating label when it's afloat, to
        // seperate it from the border
        gapPadding: 8.0,
      );

  //*=================================================
  static Border getBorder({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle borderStyle = BorderStyle.solid,
  }) {
    return Border.all(
      color: color,
      width: width,
      style: borderStyle,
    );
  }

  //*=================================================
  static BorderSide getBorderSide(
          {Color color = AppColors.white, double width = 1}) =>
      BorderSide(
        color: color,
        width: width,
      );
  //*=================================================
  /// The InputDecoration[Style of Widget's border, padding, etc] of the
  /// FormWidget[FormTextField,DropDownForm]
  static InputDecoration getFormInputDecoration({
    String? hintText,
    String? labelText,
    double verticalPaddingFactor = 0.02,
    double iconSizeFactor = 0.02,
    int errorMaxLines = 1,
    Widget? alwaysVisibleSuffixWidget,
    Widget? suffixWidget,
    Widget? prefixIcon,
    bool showAlwaysVisibleSuffixWidget = false,
    bool showSuffixWidget = true,
    Color? fillColor,
    Color? borderColor,
    Color? focusBorderColor,
    double? borderWidth,
    TextStyle? hintStyle,
    String? counterText,
    TextStyle? counterTextStyle,
    String? suffixText,
  }) =>
      InputDecoration(
        fillColor: fillColor ?? AppColors.white.withOpacity(0.7),
        filled: true,
        hintText: hintText,

        floatingLabelBehavior: FloatingLabelBehavior.auto,

        focusedBorder: getOutlineInputBorder(
          borderColor: focusBorderColor ?? AppColors.primaryColor,
          widgetType: UIWidgetType.textField,
        ),
        border: getOutlineInputBorder(
          widgetType: UIWidgetType.textField,
        ),
        enabledBorder: getOutlineInputBorder(
          borderColor: borderColor ?? AppColors.grey,
          width: borderWidth ?? 0.3,
          widgetType: UIWidgetType.textField,
        ),
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffix: showSuffixWidget ? suffixWidget : null,
        // For the [Clock] Icon at [TextField]
        suffixIcon:
            showAlwaysVisibleSuffixWidget ? alwaysVisibleSuffixWidget : null,
        errorMaxLines: errorMaxLines,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: (0.044).wf,
          vertical: (verticalPaddingFactor).hf,
        ),

        counterText: counterText,
        counterStyle: counterTextStyle, suffixText: suffixText,
      );
  //!===================== Some Gradient related methods =======================
  static final List<Color> gradientColors = [
    // Color(0xFF8C2480),
    // Color(0xFFCE587D),
    // Color(0xFFFF9485),
    AppColors.lightGrey,
    AppColors.lightPrimaryColor,
  ];
  //!===========================================================================

  static final List<Color> buttonGradientColors = [
    // Color(0xFF8C2480),
    // Color(0xFFCE587D),
    // Color(0xFFFF9485),
    AppColors.lightPrimaryColor,
    AppColors.lightGrey,
  ];
  //!===========================================================================
  static final LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientColors,
  );
  //!===========================================================================
  static final LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientColors,
  );
  //!===========================================================================
  static Shader getShader(width, height) {
    return LinearGradient(
      // reverse the color gradient in the text
      colors: List.from(gradientColors.reversed),
    ).createShader(
      Rect.fromLTWH(
        0,
        0,
        width,
        height,
      ),
    );
  }

  //!===========================================================================
  static TextStyle generalSettingTitleTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.normal,
    );
  }

  //!===========================================================================
  static List<BoxShadow>? get getShadows => [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 2.0, // soften the shadow
          spreadRadius: 0.0, //extend the shadow
          offset: const Offset(
            3.0, // Move to right x horizontally
            3.0, // Move to bottom x Vertically
          ),
        ),
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 2.0, // soften the shadow
          spreadRadius: 0.0, //extend the shadow
          offset: const Offset(
            -1.0, // Move to right x horizontally
            0.0, // Move to bottom x Vertically
          ),
        ),
      ];
  //!===========================================================================
  // Must equal the [enabled shadow ] Length
  static List<BoxShadow>? get getDisabledShadows => const [
        BoxShadow(
          color: AppColors.transparent,
          blurRadius: 0.5, // soften the shadow
        ),
        BoxShadow(
          color: AppColors.transparent,
          blurRadius: 0.5, // soften the shadow
        ),
      ];
  //*==================================================
  static BoxShadow getBoxShadow({
    double blurRadius = 3.0,
    Offset offset = const Offset(0, 0),
    double spreadRadius = 1.0,
    Color color = AppColors.primaryColor,
  }) =>
      BoxShadow(
        blurRadius: blurRadius,
        // blurStyle:blurStyle,
        offset: offset,
        spreadRadius: spreadRadius,
        color: color,
      );
  //*==================================================
  static Color? convertStringToColor(String? intColor) {
    if (intColor == null || intColor.isEmpty) return null;
    return Color(
      int.parse(
        intColor.toString().replaceAll('#', '0xff'),
      ),
    );
  }

  //*==================================================
  static Rect? getWidgetOriginPosition(key) {
    if (key?.currentContext == null) return null;
    RenderBox renderBox = key.currentContext?.findRenderObject();

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  //!===========================================================================
  //!===========================================================================
}
