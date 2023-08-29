import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/custom_animated_switcher.dart';
import '../../../widgets/empty_error/error_page.dart';

class MeetingLoadError extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final bool hasError;
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const MeetingLoadError({super.key, required this.hasError});

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSwitcher(
      child: hasError
          ? const ColoredBox(
              color: AppColors.white,
              child: ErrorPage(
                topPaddingFactor: 0.25,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
