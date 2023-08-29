import 'package:flutter/material.dart';

import '../../core/utils/design_utils.dart';
import '../../core/utils/extensions.dart';
import '../../themes/app_colors.dart';
import '../text_field_clear_widget.dart';

typedef OnSearchQueryChanged = void Function(String)?;

class SearchTextField extends StatelessWidget {
  //*================================ Properties ===============================
  final Animation<double>? animation;
  final TextEditingController? textFieldController;
  final OnSearchQueryChanged onQueryChanged;
  final OnSearchQueryChanged onQuerySubmitted;
  final VoidCallback? onTextFieldCleared;
  final String hintText;
  final Widget? suffixIcon;
  final bool showBorder;
  final double? verticalPadding;
  final double? contentHorizontalPadding;
  final double? contentVerticalPadding;
  //*================================ Constructor ==============================
  const SearchTextField({
    Key? key,
    this.animation,
    required this.textFieldController,
    this.onQueryChanged,
    this.onQuerySubmitted,
    this.onTextFieldCleared,
    this.suffixIcon,
    required this.hintText,
    this.showBorder = true,
    this.verticalPadding,
    this.contentHorizontalPadding,
    this.contentVerticalPadding,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const Color primaryColor = AppColors.primaryColor;
    final clearIconSize = (0.04).wf;

    final animation =
        this.animation ?? const AlwaysStoppedAnimation<double>(0.0);
    final textFieldContentPadding =
        (contentVerticalPadding == null && contentHorizontalPadding == null)
            ? null
            : EdgeInsets.symmetric(
                vertical: contentVerticalPadding ?? 0,
                horizontal: contentHorizontalPadding ?? 0,
              );
    //*=========================================================================
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 0,
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            border: showBorder
                ? Border.all(
                    color: primaryColor,
                    width: 5 * animation.value,
                  )
                : null,
          ),
          child: child,
        ),
        child: TextField(
          key: key,

          controller: textFieldController,
          onChanged: onQueryChanged,
          onSubmitted: onQuerySubmitted,
          decoration: InputDecoration(

            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: textFieldContentPadding,
            hintText: hintText,
            border: DesignUtils.getOutlineInputBorder(),
            prefixIcon: RotationTransition(
              turns: animation,
              child: const Icon(
                Icons.search,
              ),
            ),
            suffixIcon: suffixIcon,
            // suffixIcon: suffixIcon??null,

            suffix: TextFieldClearWidget(
              borderRadius: 100,
              textEditingController: textFieldController,
              onClearIconPressed: onTextFieldCleared,
              size: clearIconSize,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
