import 'package:equatable/equatable.dart';
import '../../enums/meeting_type.dart';
import 'meeting_group_settings_model.dart';

/// The blueprint for the singular [Room Setting]
class RoomSettingsModel extends Equatable {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final MeetingType meetingType;
  final List<MeetingGroupSettings> meetingGroupsSettings;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const RoomSettingsModel({
    required this.meetingGroupsSettings,
    required this.meetingType,
  });
  //*==================================================
  // [factory keyword is absolutely required, everything BREAKS w/o it]
  factory RoomSettingsModel.fromJson(Map<String, dynamic> json) =>
      RoomSettingsModel(
        meetingType: getMeetingType(json['engine']),
        meetingGroupsSettings: json['settings']
            .map<MeetingGroupSettings>(
              (jsonSetting) => MeetingGroupSettings.fromJson(
                jsonSetting,
                getMeetingType(json['engine']),
              ),
            )
            .toList(),
      );
  //*==================================================
  // [factory keyword is absolutely required, everything BREAKS w/o it]
  factory RoomSettingsModel.meetingSettingfromJson(Map<String, dynamic> json) =>
      RoomSettingsModel(
        meetingType: getMeetingType(json['engine_type']),
        meetingGroupsSettings: json['meeting_settings']
            .map<MeetingGroupSettings>(
              (jsonSetting) => MeetingGroupSettings.fromJson(
                jsonSetting,
                getMeetingType(json['engine']),
              ),
            )
            .toList(),
      );

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  Map<String, dynamic> toJson() => {
        'engine': meetingType,
        'settings': meetingGroupsSettings
            .map(
              (groupSettings) => groupSettings.toJson(),
            )
            .toList(),
      };
  //*=================================================
  static MeetingType getMeetingType(String? engineType) {
    if (engineType == 'Meet') {
      return MeetingType.meet;
    } else {
      return MeetingType.classroom;
    }
  }

  //*==================================================
  @override
  List<Object?> get props => [
        meetingGroupsSettings,
      ];

  //*===========================================================================
  //*===========================================================================
}
