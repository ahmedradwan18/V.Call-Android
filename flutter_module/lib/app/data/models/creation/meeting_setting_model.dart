import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../enums/meeting_type.dart';

/// The blueprint for the singular [Room Setting]
class MeetingSettingModel extends Equatable {
  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================

  final String titleAr;
  final String titleEn;

  /// used to extract the appropraite title based on language
  final String key;

  /// on/off
  final RxBool isOn;

  /// whether or not this field is editalbe [Free/Pro]
  final bool isEditable;

  final String? groupName;

  final MeetingType? engineType;

  final String? platform;

  final bool? isGeneral;

  final RxBool? isAttendee;

  final RxBool? isModeratorOnly;

  final String? descriptionEn;
  final String? descriptionAr;

  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================

  const MeetingSettingModel({
    required this.titleAr,
    required this.titleEn,
    required this.isOn,
    required this.isEditable,
    required this.key,
    this.engineType,
    this.groupName,
    this.isAttendee,
    this.isGeneral,
    this.isModeratorOnly,
    this.platform,
    this.descriptionEn,
    this.descriptionAr,
  });
  //*==================================================
  // [factory keyword is absolutely required, everything BREAKS w/o it]
  factory MeetingSettingModel.fromJson(Map<String, dynamic> json,
          String groupName, MeetingType engineType) =>
      MeetingSettingModel(
        groupName: groupName,
        titleAr: json['setting_title']['ar'],
        titleEn: json['setting_title']['en'],

        isOn: (json['setting_value'] == true).obs,
        engineType: engineType,

        descriptionEn: json['setting_description']['en'],
        descriptionAr: json['setting_description']['ar'],
        // if the api wants it to be editable
        // or if the user transformed [Free ==> Pro] and the Room was
        // created whilist free, and now i'm a pro and wants to edit it.
        isEditable: json['editable'],
        key: json['setting_key'],
        isAttendee:
            json['attendee'] == null ? null : (json['attendee'] == true).obs,
        isGeneral: json['general'],
        isModeratorOnly: json['moderator'] == null
            ? null
            : (json['attendee'] != true || json['moderator'] == true).obs,
        platform: json['platform'],
      );
  //*==================================================
  // Generate a new Setting to replace the old one, as it's fields are final
  // this is the best practise in dart, SMH
  // use all the old fields, and reverse the [value] field
  factory MeetingSettingModel.toggle(
    MeetingSettingModel oldMeeting,
    RxBool newValue,
  ) =>
      MeetingSettingModel(
        titleAr: oldMeeting.titleAr,
        titleEn: oldMeeting.titleEn,
        isOn: newValue,
        isEditable: oldMeeting.isEditable,
        key: oldMeeting.key,
      );
  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  Map<String, dynamic> toJson() => {
        'setting_title': {
          'en': titleEn,
          'ar': titleAr,
        },
        'setting_value': isOn.value,
        'editable': isEditable,
        'setting_key': key,
        'setting_description': {
          'en': descriptionEn,
          'ar': descriptionAr,
        },
      };

  Map<String, dynamic> meetSettingsToJSon() => {
        'setting_title': {
          'en': titleEn,
          'ar': titleAr,
        },
        'setting_value': isOn.value,
        'editable': isEditable,
        'setting_key': key,
        'platform': platform,
        'attendee': isOn.value == true ? isAttendee?.value : false,
        'moderator': isOn.value == true ? isModeratorOnly?.value : false,
        'general': isGeneral,
        'setting_description': {
          'en': descriptionEn,
          'ar': descriptionAr,
        },
      };

  //*==================================================
  @override
  List<Object?> get props => [
        titleAr,
        titleEn,
        isOn,
        isEditable,
        key,
      ];

  //*===========================================================================
  //*===========================================================================
}
