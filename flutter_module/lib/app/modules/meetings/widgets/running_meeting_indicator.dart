import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/utils/design_utils.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/enums/ripple_animation_type.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/animation/ripple_animation_wrapper.dart';
import '../../../widgets/buttons/custom_button.dart';

class RunningMeetingIndicator extends StatefulWidget {
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const RunningMeetingIndicator({Key? key}) : super(key: key);

  //*===========================================================================
  //*================================= State ===================================
  //*===========================================================================

  @override
  State<RunningMeetingIndicator> createState() =>
      _RunningMeetingIndicatorState();
  //*===========================================================================
  //*===========================================================================
}

class _RunningMeetingIndicatorState extends State<RunningMeetingIndicator>
    with SingleTickerProviderStateMixin {
  //*===========================================================================
  //*============================= State Methods ===============================
  //*===========================================================================
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: AppConstants.subLongDuration,
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
    super.initState();
  }

  //*==================================================
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //*===========================================================================
  //*=============================== Properties ================================
  //*===========================================================================
  late final AnimationController animationController;
  late final Animation<double> animation;
  //*===========================================================================
  //*=============================== Methods ===================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    const Color color = AppColors.red400;
    const double indicatorCircularRadius = 16;
    const double indicatorSplashSizeFactor = 0.31;
    final double indicatorButtonHeight = (0.0325).hf;
    //*=========================================================================
    return IgnorePointer(
      // T not be a button
      ignoring: true,
      child: ClipRRect(
        borderRadius: DesignUtils.getBorderRadius(),
        child: AnimatedBuilder(
          animation: animation,
          builder: (_, child) => RipplesAnimationWrapper(
            animation: animation,
            rippleType: RippleAnimationType.roundedRectangular,
            circularRadius: indicatorCircularRadius,
            splashSizeFactor: indicatorSplashSizeFactor,
            color: color,
            child: child!,
          ),
          child: Container(
            margin: const EdgeInsets.all(5.5),
            child: CustomButton(
              height: indicatorButtonHeight,
              label: ('running'.tr),
              buttonStyle: Theme.of(context)
                  .elevatedButtonTheme
                  .style
                  ?.copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      color,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        DesignUtils.getRoundedRectangleBorder(
                            radius: indicatorCircularRadius)),
                  ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
