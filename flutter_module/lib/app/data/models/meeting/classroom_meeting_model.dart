import 'package:equatable/equatable.dart';

import '../../../core/helpers/helpers.dart';
import '../../../data/enums/meeting_status.dart';
import '../../enums/meeting_type.dart';
import '../../../data/models/creation/meeting_template.dart';
import '../room/room_settings_model.dart';

/// Model for the [ClassroomMeetingModel], A.K.A a Schedueled meeting.
class ClassroomMeetingModel extends Equatable {
  //*=============================== Properties ================================
  // [meetingTitle] instead of just [title] because I inherit[extend]
  // from this class, so I need something to differentiate between meeting's
  // [title] and any of it's decendent's [title]
  final String meetingTitle;
  final String meetingDataBaseID;
  final MeetingStatus meetingStatus;
  final String meetingDate;
  final String meetingTime;
  // These I don't receive them from certain decendents[Inheriting Objs]
  // so I had to make them nullable.
  final String? roomTitle;
  final String? roomID;
  final String? meetingPassword;

  // not really apart of the [Meeting] module .. but contain some data w.r.t
  // the meeting, which are needed at [Create/Edit meeting]
  final RoomSettingsModel? settingList;
  final List<String>? invitationList;

  // to be added once the user clicks on [StartMeeting] and I call a few Api(s)
  final String link;
  final String recordingLink;
  final String? ownerEmail;
  final bool? isActive;

  final MeetingType engineType;

  //*=============================== Constructor ===============================
  const ClassroomMeetingModel({
    required this.meetingTitle,
    required this.meetingStatus,
    required this.meetingDataBaseID,
    required this.meetingDate,
    required this.meetingTime,
    required this.engineType,
    this.meetingPassword = '',
    this.recordingLink = '',
    this.settingList,
    this.invitationList,
    this.roomTitle,
    this.roomID,
    this.isActive,
    this.link = '',
    // not used

    this.ownerEmail,
  });
  //*=================================================
  // To create a new [Meeting] from the old one after destroying it, by
  //  changing some parameters .. DART PREFFERED APPROACH.
  factory ClassroomMeetingModel.fromOld({
    required dynamic oldMeeting,
    required MeetingStatus newStatus,
    String? title,
    String? roomTitle,
    String? password,
    String? link,
    String? inputStartTime,
    String? inputDate,
    String? dataBaseID,
    String? roomID,
    bool? isActive = true,
    RoomSettingsModel? settingList,
    List<String>? invitationList,
    String? recordingLink,
    MeetingType? engineType,
  }) =>
      ClassroomMeetingModel(
        meetingStatus: newStatus,
        meetingDate: inputDate ?? oldMeeting.meetingDate,
        meetingTime: inputStartTime ?? oldMeeting.meetingTime,
        link: link ?? oldMeeting.link,
        meetingTitle: title ?? oldMeeting.meetingTitle,
        roomTitle: roomTitle ?? oldMeeting.roomTitle,
        meetingDataBaseID: dataBaseID ?? oldMeeting.meetingDataBaseID,
        roomID: roomID ?? oldMeeting.roomID,
        settingList: settingList ?? oldMeeting.settingList,
        invitationList: invitationList ?? oldMeeting.invitationList,
        meetingPassword: password ?? oldMeeting.meetingPassword,
        recordingLink: recordingLink ?? oldMeeting.recordingLink,
        engineType: engineType ?? oldMeeting.engineType,
        isActive: isActive ?? oldMeeting.isActive,
      );
  //*=================================================
  factory ClassroomMeetingModel.fromJson(Map<String, dynamic> jsonMeeting) =>
      ClassroomMeetingModel(
        // used
        meetingTitle: jsonMeeting['title'],
        isActive: jsonMeeting['active'] == 1 ? true : false,
        meetingStatus: getMeetingStatus(jsonMeeting['meeting_status']),
        meetingDate: jsonMeeting['meeting_date'],
        meetingTime: jsonMeeting['meeting_time'],
        roomTitle: jsonMeeting['room_name'],
        meetingDataBaseID: jsonMeeting['name'],
        roomID: jsonMeeting['room_id'],
        settingList: Helpers.extractMeetingSettingsFromJson(
          jsonMeeting['meeting_settings'],
          MeetingType.classroom.label,
        ),
        invitationList: extractContacts(jsonMeeting['invitations']),
        link: jsonMeeting['meeting_url'] ?? '',
        // not used

        ownerEmail: jsonMeeting['owner'],

        meetingPassword: jsonMeeting['password'],
        recordingLink: jsonMeeting['recording_url'] ?? '',
        engineType: MeetingType.classroom,
      );
  //*=================================================
  factory ClassroomMeetingModel.fromTemplate(
    MeetingTemplate template, {
    RoomSettingsModel? settingList,
  }) =>
      ClassroomMeetingModel(
        // Database ID
        meetingTitle: template.title,
        meetingStatus: getMeetingStatus(template.isScheduled.toString()),
        meetingDataBaseID: template.id,
        meetingDate: template.date,
        meetingTime: template.time,
        link: template.link,
        roomID: template.roomID,
        roomTitle: template.roomTitle,
        meetingPassword: template.password,
        settingList: settingList ?? template.settingList!,

        engineType: template.engineType,
        isActive: template.isActive,
      );
  //*=================================================
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // used
    data['title'] = meetingTitle;
    data['meeting_status'] = meetingStatus.statusString;
    data['meeting_date'] = meetingDate;
    data['meeting_time'] = meetingTime;
    data['meeting_url'] = link;
    data['room_name'] = roomTitle;
    data['name'] = meetingDataBaseID;
    data['room_id'] = roomID;
    data['engineType'] = engineType;
    // Not used

    data['owner'] = ownerEmail;

    data['password'] = meetingPassword;

    data['recording_url'] = recordingLink;
    return data;
  }

  //*===========================================================================
  static MeetingStatus getMeetingStatus(String status) {
    switch (status) {
      case 'Not Started':
      // isSchedueld = true
      case 'true':
        return MeetingStatus.upcoming;
      case 'Started':
      case 'false':
        return MeetingStatus.started;
      case 'Ended':
        return MeetingStatus.log;
      default:
        return MeetingStatus.upcoming;
    }
  }

  //*===========================================================================
  static List<String>? extractContacts(jsonContactMap) {
    if (jsonContactMap == null) return null;
    return jsonContactMap.map((map) => map['student_id']).toList();
  }

  //*===========================================================================
  @override
  List<Object?> get props => [
        meetingDataBaseID,
      ];

  //*===========================================================================
  //*===========================================================================
}
