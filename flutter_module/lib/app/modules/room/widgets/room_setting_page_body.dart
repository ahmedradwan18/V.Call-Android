import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import '../../../core/values/app_constants.dart';
import '../../../data/models/room/room_model.dart';
import '../../../data/models/room/room_settings_model.dart';
import '../../../data/typedefs/app_typedefs.dart';
import '../../../widgets/settings/meeting_settings.dart';
import 'engine_switch_type.dart';

class RoomSettingPageBody extends StatelessWidget {
  //*===========================================================================
  //*================================ Properties ===============================
  //*===========================================================================
  final RoomModel room;
  final List<RoomSettingsModel> roomSettings;
  final double? horizontalPadding;
  final double? height;
  final OnToggleMeetingSetting onToggleSetting;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  const RoomSettingPageBody({
    super.key,
    required this.room,
    required this.onToggleSetting,
    required this.roomSettings,
    this.horizontalPadding,
    this.height,
  });

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================

    //*=========================================================================
    return DefaultTabController(
      length: roomSettings.length,
      animationDuration: AppConstants.mediumDuration,
      initialIndex: room.engineType.index,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? (0.06).wf,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EngineSwitchType(
              room: room,
              settings: roomSettings,
            ),
            //* Room Settings List
            SizedBox(
              height: height ?? 0.7.hf,
              child: TabBarView(
                children: roomSettings.map(
                  (setting) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MeetingSettings(
                        settingList: setting,
                        onToggleSetting: onToggleSetting,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
