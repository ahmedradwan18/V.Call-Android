import 'package:flutter/material.dart';

import '../../core/utils/design_utils.dart';
import '../../core/values/app_constants.dart';
import '../../themes/app_colors.dart';
import 'package:animations/animations.dart';

class OpenContainerWrapper extends StatelessWidget {
  //*================================ Properties ===============================
  final Widget openedChild;
  final Widget closedChild;
  final Duration duration;
  final ShapeBorder? shape;
  final double closedElevation;
  final Color closedColor;
  final Function(Never?)? onClosed;
  final RouteSettings? routeSettings;
  final bool useRootNavigator;
  final ContainerTransitionType transitionType;
  final Function? onOpen;
  //*================================ Constructor ==============================
  const OpenContainerWrapper({
    Key? key,
    required this.openedChild,
    required this.closedChild,
    this.duration = AppConstants.subMediumDuration,
    this.shape,
    this.closedElevation = 5.0,
    this.closedColor = AppColors.white,
    this.onClosed,
    this.onOpen,
    this.routeSettings,
    required this.useRootNavigator,
    this.transitionType = ContainerTransitionType.fade,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (_, closedContainer) {
        if (onOpen != null) onOpen!();
        return openedChild;
      },
      transitionDuration: duration,
      transitionType: transitionType,
      closedShape: DesignUtils.getRoundedRectangleBorder(),
      closedElevation: closedElevation,
      closedColor: closedColor,
      onClosed: onClosed,
      closedBuilder: (_, openContainer) => closedChild,
      openElevation: 0.0,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
    );
  }
  //*===========================================================================
}
