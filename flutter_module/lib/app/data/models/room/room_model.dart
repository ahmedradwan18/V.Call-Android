import 'package:equatable/equatable.dart';
import '../../enums/meeting_type.dart';
import '../creation/meeting_setting_model.dart';

class RoomModel extends Equatable {
  //*================================ Properties ===============================
  final String title;
  final String id;
  final String description;
  final String moderatorLink;
  final String attendeeLink;
  final MeetingType engineType;

  final bool isActive;
  final List<MeetingSettingModel>? generalSettings;

  //*================================ Constructor ==============================
  const RoomModel({
    required this.title,
    required this.description,
    required this.id,
    required this.moderatorLink,
    required this.attendeeLink,
    required this.engineType,
    required this.generalSettings,
    // by default, new rooms are active
    this.isActive = true,
  });
  //*================================= Methods =================================
  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        title: json['title'],
        id: json['name'], // ID From the database is called [name]
        description: json['description'] ?? '',
        moderatorLink: json['moderator_url'] ?? '',
        attendeeLink: json['attendee_url'] ?? '',
        isActive: (json['active'].toString().toLowerCase() == 'true') ||
            (int.tryParse(json['active'].toString()) == 1),
        engineType: getMeetingType(json['engine_type']),
        generalSettings: (json['general_settings'] ?? [])
            .map<MeetingSettingModel>(
              (jsonSetting) => MeetingSettingModel.fromJson(
                jsonSetting,
                '',
                MeetingType.classroom,
              ),
            )
            .toList(),
      );
  //*=================================================
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['name'] = id; // ID From the database is called [name]
    data['description'] = description;
    data['moderator_url'] = moderatorLink;
    data['attendee_url'] = attendeeLink;
    data['active'] = isActive;
    data['engine_type'] = engineType;
    data['general_settings'] = generalSettings!.map(
      (meetingSetting) {
        return meetingSetting.toJson();
      },
    ).toList();
    return data;
  }

  //*=================================================
  factory RoomModel.fromOld({
    required RoomModel oldRoom,
    String? title,
    String? id,
    String? moderatorLink,
    String? attendeeLink,
    String? description,
    MeetingType? engineType,
    bool? isActive,
    List<MeetingSettingModel>? generalSettings,
  }) =>
      RoomModel(
        title: title ?? oldRoom.title,
        id: id ?? oldRoom.id,
        description: description ?? oldRoom.description,
        moderatorLink: moderatorLink ?? oldRoom.moderatorLink,
        attendeeLink: attendeeLink ?? oldRoom.attendeeLink,
        isActive: isActive ?? oldRoom.isActive,
        engineType: engineType ?? oldRoom.engineType,
        generalSettings: generalSettings ?? oldRoom.generalSettings,
      );
  //*=================================================
  static MeetingType getMeetingType(String? engineType) {
    if (engineType == 'Meet') {
      return MeetingType.meet;
    } else {
      return MeetingType.classroom;
    }
  }

  //*=================================================

  // used for comparison
  @override
  List<Object?> get props => [
        title,
        id,
        description,
        moderatorLink,
        attendeeLink,
        isActive,
        engineType,
      ];
  //*===========================================================================
  //*===========================================================================
}
