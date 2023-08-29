import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../core/helpers/meeting_helper.dart';
import '../core/utils/design_utils.dart';
import '../data/enums/button_type.dart';
import '../data/enums/ripple_animation_type.dart';
import '../data/typedefs/app_typedefs.dart';
import 'animation/ripple_animation_wrapper.dart';
import 'buttons/animated_button.dart';
import 'buttons/custom_button.dart';
import 'custom_spacer.dart';

class CreationSheetButtons extends StatelessWidget {
  //*================================ Properties ===============================
  final dynamic meeting;
  final FutureVoidCallback onRunMeeting;
  final Animation<double> animation;
  final bool isLoading;
  final GlobalKey shareWidgetKey;
  //*================================ Constructor ==============================
  const CreationSheetButtons({
    required this.meeting,
    required this.onRunMeeting,
    Key? key,
    required this.animation,
    required this.isLoading,
    required this.shareWidgetKey,
  }) : super(key: key);

  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const double customSpacerWidthFactor2 = 0.035;

    final buttonHeight = (0.055).hf;
    final startIconSize = (0.03).hf;
    final shareIconSize = (0.025).hf;
    final runButtonLabel = 'run_meeting'.tr;
    final shareButtonLabel = 'share'.tr;
    //*=========================================================================
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const CustomSpacer(
          widthFactor: customSpacerWidthFactor2,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: animation,
            builder: (_, child) => Container(
              padding: EdgeInsets.symmetric(
                vertical: animation.value * 13,
              ),
              child: child,
            ),
            child: ClipRRect(
              borderRadius: DesignUtils.getBorderRadius(),
              child: AnimatedBuilder(
                animation: animation,
                builder: (_, child) => RipplesAnimationWrapper(
                  animation: animation,
                  rippleType: RippleAnimationType.roundedRectangular,
                  circularRadius: DesignUtils.defaultBorderRadiusValue,
                  child: child!,
                ),
                child: Container(
                  margin: const EdgeInsets.all(5.5),
                  child: AnimatedButton(
                    buttonType: ButtonType.elevatedButtonWithIcon,
                    isLoading: isLoading,
                    label: (runButtonLabel),
                    onPressed: onRunMeeting,
                    height: buttonHeight,
                    icon: Icon(
                      Icons.video_call_rounded,
                      size: startIconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const CustomSpacer(
          widthFactor: customSpacerWidthFactor2,
        ),
        Expanded(
          child: CustomButton(
            key: shareWidgetKey,
            buttonType: ButtonType.elevatedButtonWithIcon,
            label: (shareButtonLabel),
            onPressed: () async => await MeetingHelper.onShareMeeting(
              meeting: meeting,
              widgetKey: shareWidgetKey,
            ),
            icon: Icon(
              Icons.share,
              size: shareIconSize,
            ),
            height: buttonHeight,
          ),
        ),
        const CustomSpacer(
          widthFactor: customSpacerWidthFactor2,
        ),
      ],
    );
  }
  //*===========================================================================
  //*===========================================================================
}
