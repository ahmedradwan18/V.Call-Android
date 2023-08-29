import 'package:flutter/material.dart';
import '../core/utils/design_utils.dart';
import 'custom_tool_tip.dart';
import 'text/custom_text.dart';

class LockingWidget extends StatelessWidget {
  //*================================ Properties ===============================
  final String? toolTipMessage;
  final ShapeBorder? shapeBorder;
  final Widget child;
  final bool showLockWidget;
  final bool showMessage;
  // TO toggle locking on and off based on external condition
  final bool isLocked;
  final TooltipTriggerMode tooltipTriggerMode;
  final double? messageEndPostion;
  final TextStyle? messageTextStyle;
  final Widget? lockWidget;
  final bool transparentLock;
  //*================================ Constructor ==============================
  const LockingWidget({
    required this.child,
    Key? key,
    this.toolTipMessage,
    this.shapeBorder,
    this.tooltipTriggerMode = TooltipTriggerMode.longPress,
    this.showLockWidget = false,
    this.transparentLock = false,
    this.showMessage = false,
    this.isLocked = true,
    this.messageEndPostion,
    this.messageTextStyle,
    this.lockWidget,
  }) : super(key: key);
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final toolTipMessage = this.toolTipMessage ?? '';
    //*=========================================================================
    return ClipRRect(
      borderRadius: DesignUtils.getBorderRadius(),
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.passthrough,
        children: [
          child,
          Positioned.fill(
            child: (!isLocked)
                ? const SizedBox.shrink()
                : CustomToolTip(
                    message: toolTipMessage,
                    tooltipTriggerMode: tooltipTriggerMode,
                    child: ColoredBox(
                      color: transparentLock
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
          ),
          if (isLocked && showLockWidget)
            lockWidget ?? const Icon(Icons.lock_outline),
          if (isLocked && showMessage)
            PositionedDirectional(
              end: messageEndPostion,
              child: CustomText(
                toolTipMessage,
                style: messageTextStyle,
              ),
            ),
        ],
      ),
    );
  }
  //*===========================================================================
}
