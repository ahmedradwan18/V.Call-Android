import 'package:equatable/equatable.dart';
import '../../enums/meeting_type.dart';
import '../creation/meeting_setting_model.dart';

/// The blueprint for the singular [Room Setting]
class MeetingGroupSettings extends Equatable {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  final String groupNameAr;
  final String groupNameEn;
  final List<MeetingSettingModel> meetingSettings;
  final MeetingType engineType;
  final String groupIcon;
  final String? groupKey;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const MeetingGroupSettings({
    required this.meetingSettings,
    required this.groupNameAr,
    required this.groupNameEn,
    required this.engineType,
    required this.groupIcon,
    this.groupKey,
  });
  //*==================================================
  // [factory keyword is absolutely required, everything BREAKS w/o it]
  factory MeetingGroupSettings.fromJson(
          Map<String, dynamic> json, MeetingType engineType) =>
      MeetingGroupSettings(
        groupNameAr: json['group_title']['ar'],
        groupNameEn: json['group_title']['en'],
        groupKey: json['group_key'],
        groupIcon: json['group_icon'],
        engineType: engineType,
        meetingSettings: json['group_settings']
            .map<MeetingSettingModel>(
              (jsonSetting) => MeetingSettingModel.fromJson(
                jsonSetting,
                json['group_title']['en'],
                engineType,
              ),
            )
            .toList(),
      );

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================
  Map<String, dynamic> toJson() => {
        'group_title': {
          'en': groupNameEn,
          'ar': groupNameAr,
        },
        'group_icon': groupIcon,
        'group_key': groupKey,
        'group_settings': meetingSettings.map(
          (meetingSetting) {
            if (engineType == MeetingType.meet) {
              return meetingSetting.meetSettingsToJSon();
            } else {
              return meetingSetting.toJson();
            }
          },
        ).toList()
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
        meetingSettings,
      ];

  //*===========================================================================
  //*===========================================================================
}
