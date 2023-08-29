import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:flutter_module/app/widgets/textfields/text_field_header.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../core/utils/design_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';

class CustomTextField extends StatelessWidget {
  //*=============================== Properties ================================
  // this will be used to invoke the correct 'validate' and 'submit'
  // methods on the correct
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextAlign? textAlign;

  /// padding for entire field, to help with flying-label not being entirly
  /// visible
  final double? verticalPadding;
  final double? horizontalPadding;

  /// The Flying Text
  final String? headerText;
  final IconData? headerIconData;
  final Widget? headerIcon;
  final String? suffixText;
  final String? Function(String?)? onValidateHandler;
  final Function(String)? onChangedHandler;
  final TextInputType keyboardType;

  final double? verticalContentPaddingFactor;
  final Function()? onClearIconPressed;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;

  /// for date picker.
  final bool isReadOnly;
  final String? initialValue;
  final TextStyle? textStyle;

  final bool showAlwaysVisibleSuffixWidget;
  final bool showSuffixWidget;
  final Widget? alwaysVisibleSuffixWidget;
  final Widget? suffixWidget;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  /// for description textField
  final int? minLines;
  final int? maxLines;
  final int errorMaxLines;
  final InputDecoration? decoration;
  final Color? fillColor;
  final Color? borderColor;
  final Color? cursorColor;
  final Color? focusBorderColor;
  final double? borderWidth;
  final TextStyle? hintStyle;

  final String? counterText;
  final TextStyle? counterTextStyle;

  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;

  //*=============================== Constructor ===============================
  const CustomTextField({
    this.hintText,
    this.headerText,
    this.headerIconData,
    this.onValidateHandler,
    this.horizontalPadding,
    this.verticalPadding,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false,
    this.verticalContentPaddingFactor,
    this.onClearIconPressed,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.errorMaxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.showSuffixWidget = true,
    this.showAlwaysVisibleSuffixWidget = false,
    this.onChangedHandler,
    this.textEditingController,
    this.textAlign,
    this.onTap,
    this.initialValue,
    this.inputFormatters,
    this.textStyle,
    this.decoration,
    this.alwaysVisibleSuffixWidget,
    this.suffixWidget,
    this.fillColor,
    this.cursorColor,
    this.borderColor,
    this.borderWidth,
    this.focusBorderColor,
    this.hintStyle,
    Key? key,
    this.counterText,
    this.counterTextStyle,
    this.suffixText,
    this.maxLengthEnforcement,
    this.prefixIcon,
    this.headerIcon,
  }) : super(key: key);
  //*================================ Methods ==================================

  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final maxLines = this.maxLines ?? ((minLines ?? 0) + 1);
    final verticalPadding = this.verticalPadding ?? (0.006).hf;
    final horizontalPadding = this.horizontalPadding ?? 0.0;
    final verticalContentPaddingFactor =
        this.verticalContentPaddingFactor ?? 0.015;
    final fallbackTextStyle = AppTextTheme.bodyText2(color: AppColors.grey);
    final hintText = this.hintText ?? 'type_here'.tr;
    final textStyle = this.textStyle ??
        Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.primaryColor);
    //*=========================================================================
    // for the entire card 'text field'
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Field Header/Title,
          if (headerText != null &&
              (headerIcon != null || headerIconData != null))
            TextFieldHeader(
              label: headerText!,
              icon: headerIcon,
              iconData: headerIconData,
            ),

          // Field
          Flexible(
            child: TextFormField(
              onTap: onTap,
              inputFormatters: inputFormatters,

              minLines: minLines,
              maxLines: maxLines,
              initialValue: initialValue,
              readOnly: isReadOnly,

              // to move the focus of the text when the user clicks [Next]
              onFieldSubmitted: (_) => textInputAction == TextInputAction.next
                  ? FocusScope.of(context).nextFocus()
                  : FocusScope.of(context).unfocus(),

              controller: textEditingController,
              // validate the user inputed data
              validator: onValidateHandler,
              // call different things based on the form field
              // sendValue to be used in [meetingTemplage]
              onChanged: onChangedHandler,
              keyboardType: keyboardType,
              textAlign: textAlign ?? TextAlign.start,
              textInputAction: textInputAction,
              autocorrect: false,
              cursorWidth: 2,
              maxLength: maxLength,
              obscureText: obscureText,

              decoration: decoration ??
                  DesignUtils.getFormInputDecoration(
                    errorMaxLines: errorMaxLines,
                    showAlwaysVisibleSuffixWidget:
                        showAlwaysVisibleSuffixWidget,
                    showSuffixWidget: showSuffixWidget,
                    fillColor: fillColor,
                    suffixWidget: suffixWidget,
                    alwaysVisibleSuffixWidget: alwaysVisibleSuffixWidget,
                    hintText: hintText,
                    verticalPaddingFactor: verticalContentPaddingFactor,
                    borderColor: borderColor,
                    borderWidth: borderWidth,
                    focusBorderColor: focusBorderColor,
                    hintStyle: hintStyle ?? fallbackTextStyle,
                    counterText: counterText,
                    counterTextStyle: counterTextStyle,
                    suffixText: suffixText,
                    prefixIcon: prefixIcon,
                  ),

              obscuringCharacter: '◉',
              cursorColor: cursorColor ?? AppColors.primaryColor,
              textAlignVertical: TextAlignVertical.center,
              style: textStyle,
              maxLengthEnforcement: maxLengthEnforcement,
            ),
          ),
        ],
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
