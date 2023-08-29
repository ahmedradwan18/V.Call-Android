import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/app_constants.dart';
import '../../data/enums/meeting_type.dart';
import '../../data/typedefs/app_typedefs.dart';
import '../../themes/app_colors.dart';
import '../custom_animated_switcher.dart';
import '../custom_divider.dart';
import '../settin_switch_tile.dart';
import '../text/custom_text.dart';

class SettingsBody extends StatelessWidget {
  //*================================ Parameters ===============================
  final List<dynamic> settings;
  final OnToggleMeetingSetting onToggleSetting;

  //*================================ Constructor ==============================
  const SettingsBody({
    required this.settings,
    required this.onToggleSetting,
    super.key,
  });
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    return Container(
      decoration: const BoxDecoration(
        borderRadius:
            BorderRadius.only(bottomLeft: radius, bottomRight: radius),
        color: Colors.white,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
          children: settings.map(
        (settingTile) {
          return Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingSwitchTile(
                  setting: settingTile,
                  onToggleSetting: onToggleSetting,
                ),
                CustomAnimatedSwitcher(
                  animationDuration: AppConstants.longDuration,
                  child: settingTile.isOn.value
                      ? settingTile.isEditable
                          ? settingTile.engineType == MeetingType.meet
                              ? !settingTile?.isGeneral!
                                  ? AnimatedScale(
                                      scale: 1.0,
                                      duration: AppConstants.longDuration,
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                            value: settingTile
                                                .isModeratorOnly!.value as bool,
                                            title: CustomText('moderator'.tr),
                                            activeColor: AppColors.primaryColor,
                                            groupValue: true,
                                            onChanged: (val) {
                                              settingTile.isModeratorOnly!(
                                                  !settingTile
                                                      .isModeratorOnly!.value);

                                              if (!settingTile
                                                      .isModeratorOnly!.value &&
                                                  !settingTile
                                                      .isAttendee!.value) {
                                                settingTile.isOn(false);
                                              }
                                            },
                                            visualDensity: const VisualDensity(
                                                horizontal: VisualDensity
                                                    .minimumDensity,
                                                vertical: VisualDensity
                                                    .minimumDensity),
                                            toggleable: true,
                                          ),
                                          RadioListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: VisualDensity
                                                    .minimumDensity,
                                                vertical: VisualDensity
                                                    .minimumDensity),
                                            value: settingTile.isAttendee!.value
                                                as bool,
                                            title: CustomText('attendee'.tr),
                                            groupValue: true,
                                            activeColor: AppColors.primaryColor,
                                            onChanged: (dynamic) {
                                              settingTile.isAttendee!(
                                                  !settingTile
                                                      .isAttendee!.value);

                                              if (!settingTile
                                                      .isModeratorOnly!.value &&
                                                  !settingTile
                                                      .isAttendee!.value) {
                                                settingTile.isOn(false);
                                              }
                                            },
                                            // selected: true,
                                            toggleable: true,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                              : const SizedBox()
                          : const SizedBox()
                      : const SizedBox(),
                ),
                settings.last == settingTile
                    ? const SizedBox()
                    : const CustomDivider(),
              ],
            ),
          );
        },
      ).toList()),
    );
  }
  //*===========================================================================
}
