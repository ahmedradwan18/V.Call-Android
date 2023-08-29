import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/dialog_helper.dart';
import '../themes/app_colors.dart';
import 'dismissible_background_widget.dart';

class DismissibleWidget extends StatelessWidget {
  //*=============================== Properties ================================
  final Function onDismiss;
  // if the swiping is both ways
  final Function? onApply;

  /// Option to not confrim on safe actions, for example moving invitation
  /// from accepted to rejected is not that dangerous, it's reversable
  final bool confirmDismiss;
  final Widget child;
  // nullabe to use [.tr text a default value], and that is unacceptable
  // at constructor level.
  final String? dismissBackgroundText;
  final String? acceptBackgroundText;
  final String title;
  final String name;

  // styling

  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;

  //*=============================== Constructor ===============================
  const DismissibleWidget(
      {required this.onDismiss,
      required this.child,
      required this.title,
      required this.name,
      this.confirmDismiss = true,
      this.dismissBackgroundText,
      this.acceptBackgroundText,
      this.onApply,
      this.verticalPaddingFactor = 0.02,
      this.horizontalPaddingFactor = 0.02,
      this.horizontalMarginFactor = 0.012,
      this.verticalMarginFactor = 0.012,
      Key? key})
      : super(key: key);
  //*================================ Methods ==================================
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: !confirmDismiss
          ? null
          : (direction) async {
              if (direction == DismissDirection.startToEnd) return true;
              return DialogHelper.showDeletePrompt(
                title: title,
                itemType: name,
              );
            },
      onDismissed: (direction) async {
        direction == DismissDirection.endToStart
            ? await onDismiss()
            : await onApply!();
      },
      // if no [onAccept] was provided, then restrict the dismissing to avoid
      // errors from method above, and logical error.
      direction: onApply == null
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,

      // incase of deletion [second action at meeting invitation card]
      secondaryBackground: DismissibleBackgroundWidget(
        alignmentDirectional: AlignmentDirectional.centerEnd,
        text: dismissBackgroundText ?? '${'delete_this'.tr}!',
        color: AppColors.errorColor,
        verticalPaddingFactor: verticalPaddingFactor,
        horizontalPaddingFactor: horizontalPaddingFactor,
        horizontalMarginFactor: horizontalMarginFactor,
        verticalMarginFactor: verticalMarginFactor,
      ),
      // incase of accepting [First action at meeting invitation card]
      background: DismissibleBackgroundWidget(
        alignmentDirectional: AlignmentDirectional.centerStart,
        text: acceptBackgroundText ?? '',
        color: AppColors.snackBarInformationColor,
        verticalPaddingFactor: verticalPaddingFactor,
        horizontalPaddingFactor: horizontalPaddingFactor,
        horizontalMarginFactor: horizontalMarginFactor,
        verticalMarginFactor: verticalMarginFactor,
      ),
      child: child,
    );
  }
  //*===========================================================================
}
