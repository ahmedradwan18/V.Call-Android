import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'navigation/back_arrow.dart';
import 'text/custom_text.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  //*================================ Properties ===============================
  final String? title;
  final TextStyle? titleStyle;
  final Function()? onBackPressed;
  final Widget? titleWidget;
  final bool hasBackArrow;
  final Color? color;

  //*================================ Constructor ==============================
  const SimpleAppBar({
    this.title,
    Key? key,
    this.hasBackArrow = true,
    this.onBackPressed,
    this.titleStyle,
    this.titleWidget,
    this.color,
  }) : super(key: key);

  //*================================= Methods =================================

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  //*==================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const iconColor = Colors.black45;

    final titleTdextStyle =
        titleStyle ?? AppTheme.appTheme.textTheme.titleLarge;
    //*=========================================================================
    return AppBar(
      centerTitle: true,
      backgroundColor: color ?? AppTheme.appTheme.scaffoldBackgroundColor,
      elevation: 0.0,
      title: titleWidget ??
          CustomText(
            title!,
            style: titleTdextStyle,
          ),
      automaticallyImplyLeading: false,
      leading: hasBackArrow
          ? BackArrow(
              color: iconColor,
              onPressed: onBackPressed,
            )
          : null,
    );
  }

  //*===========================================================================
  //*===========================================================================
}
