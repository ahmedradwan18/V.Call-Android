import 'package:flutter/material.dart';
import '../../core/utils/localization_service.dart';
import '../../core/values/app_constants.dart';
import '../../data/models/room/meeting_group_settings_model.dart';
import '../../themes/app_text_theme.dart';
import '../custom_spacer.dart';
import '../custom_svg_network.dart';
import '../text/custom_text.dart';
import 'dart:math' as math;

class SettingsTitle extends StatelessWidget {
  //*================================ Parameters ===============================
  final double animationValue;
  final bool isExpaned;
  final MeetingGroupSettings settings;
  //*================================ Constructor ==============================

  const SettingsTitle({
    super.key,
    required this.animationValue,
    required this.isExpaned,
    required this.settings,
  });
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    //*=============================== Parameters ==============================
    const radius = Radius.circular(10);
    //*=========================================================================
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: isExpaned ? Radius.zero : radius,
          bottomRight: isExpaned ? Radius.zero : radius,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const CustomSpacer(widthFactor: 0.013),
          CustomNetworkSvg(
            svgPath: settings.groupIcon,
            widthFactor: 0.06,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              LocalizationService.appLanguage == AppConstants.english
                  ? settings.groupNameEn
                  : settings.groupNameAr,
              style: AppTextTheme.boldPrimaryBodyText1,
            ),
          ),
          const Spacer(),
          Transform.rotate(
            angle: math.pi * animationValue * 1.5,
            alignment: Alignment.center,
            child: const Icon(Icons.chevron_left, size: 40),
          )
        ],
      ),
    );
  }
  //*===========================================================================
}
