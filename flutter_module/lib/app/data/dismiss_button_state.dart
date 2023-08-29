import 'package:flutter/widgets.dart';

import '../themes/app_colors.dart';

enum DismissButtonState {
  back,
  cancel,
}

extension DismissButtonStateExtension on DismissButtonState {
  String get label {
    switch (this) {
      case DismissButtonState.back:
        return 'back';

      case DismissButtonState.cancel:
        return 'cancel';

      default:
        return 'dismiss';
    }
  }

  //*==================================================
  Color get color {
    switch (this) {
      case DismissButtonState.back:
        return AppColors.primaryColor;

      case DismissButtonState.cancel:
        return AppColors.dangerColor;

      default:
        return AppColors.dangerColor;
    }
  }
}
