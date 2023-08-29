import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/app/widgets/settings/setting_group_name.dart';
import '../../core/values/app_constants.dart';
import '../../data/models/room/room_settings_model.dart';
import '../../data/typedefs/app_typedefs.dart';
import 'setting_body.dart';

class MeetingSettings extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final RoomSettingsModel settingList;
  final OnToggleMeetingSetting onToggleSetting;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const MeetingSettings({
    required this.settingList,
    required this.onToggleSetting,
    super.key,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: settingList.meetingGroupsSettings.map(
        (setting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ExpansionWidget(
              initiallyExpanded: false,
              duration: AppConstants.mediumDuration,
              titleBuilder:
                  (double animationValue, _, bool isExpaned, toogleFunction) {
                return InkWell(
                  onTap: () => toogleFunction(animated: true),
                  child: SettingsTitle(
                    animationValue: animationValue,
                    isExpaned: isExpaned,
                    settings: setting,
                  ),
                );
              },
              content: SettingsBody(
                settings: setting.meetingSettings,
                onToggleSetting: onToggleSetting,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
