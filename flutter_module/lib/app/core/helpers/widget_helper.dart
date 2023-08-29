import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../themes/app_colors.dart';
import '../utils/logging_service.dart';

class WidgetHelper {
  //*===========================================================================
  //*=============================== Constructor ===============================
  //*===========================================================================
  static const WidgetHelper _singleton = WidgetHelper._internal();
  factory WidgetHelper() {
    return _singleton;
  }
  const WidgetHelper._internal();
  //*===========================================================================
  //*=============================== Properties ================================
  //*===========================================================================

  //*===========================================================================
  //*================================ Methods ==================================
  //*===========================================================================
  static SuperTooltip? showToolTip({
    required BuildContext context,
    required Widget child,
    VoidCallback? onClose,
    VoidCallback? onOpen,
    double arrowLength = 20.0,
    double? bottomMargin,
    double? horizontalMargin,
    Color? backgroundColor,
    bool hasShadow = false,
  }) {
    try {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      final targetGlobalCoordinates = renderBox.localToGlobal(
        renderBox.size.center(Offset.zero),
      );

      // where the hit target is, relative to the screen height,
      // i.e. in the last (1/3)/(1/4) of the scrren - starting up to bottom
      final bottomCloseness =
          (1 - (context.height - targetGlobalCoordinates.dy) / context.height);

      final popupDirection =
          (bottomCloseness < 0.8) ? TooltipDirection.down : TooltipDirection.up;

      final tooltip = SuperTooltip(
        popupDirection: popupDirection,
        arrowTipDistance: (0.025).hf,
        content: child,
        arrowLength: arrowLength,
        borderWidth: (0.003).wf,
        backgroundColor: backgroundColor ?? const Color(0xffE9E9E9),
        borderColor: const Color(0xffDFDFDF),
        outsideBackgroundColor: AppColors.transparent,
        hasShadow: hasShadow,
        shadowSpreadRadius: 7,
        shadowBlurRadius: 10.0,
        shadowColor: AppColors.shadowColor,
        // minimumOutsideMargin: 0.0,
        onClose: onClose,
        bottom: bottomMargin,
        left: horizontalMargin,
        right: horizontalMargin,
      );

      tooltip.show(context);

      if (onOpen != null) onOpen();
      return tooltip;
    } catch (e) {
      LoggingService.error(
        'Error at Method: showToolTip -- widget_helper.dart',
        e,
        StackTrace.current,
      );
    }
    return null;
  }
  //*===========================================================================
  //*===========================================================================
}
