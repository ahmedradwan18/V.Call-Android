import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../data/enums/meeting_status.dart';
import '../../../data/models/creation/meeting_template.dart';
import '../../enums/meeting_type.dart';

/// Model for the [MeetMeetingModel], A.K.A a Schedueled meeting.
class MeetMeetingModel extends Equatable {
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
  final String? userName;
  final String? userEmail;
  final String? meetingPassword;

  // not really apart of the [Meeting] module .. but contain some data w.r.t
  // the meeting, which are needed at [Create/Edit meeting]
  final Map<String, dynamic>? settingList;
  final List<String>? invitationList;

  // to be added once the user clicks on [StartMeeting] and I call a few Api(s)
  final String link;
  final String recordingLink;
  final String? ownerEmail;
  final MeetingType engineType;
  final bool? isActive;

  final String token;
  final String domain;

  //*=============================== Constructor ===============================
  const MeetMeetingModel({
    required this.meetingTitle,
    required this.meetingStatus,
    required this.meetingDataBaseID,
    required this.meetingDate,
    required this.meetingTime,
    required this.engineType,
    required this.token,
    required this.domain,
    this.meetingPassword = '',
    this.recordingLink = '',
    this.settingList,
    this.userEmail,
    this.invitationList,
    this.roomTitle,
    this.roomID,
    this.userName,
    this.link = '',
    this.isActive = true,
    // not used

    this.ownerEmail,
  });
  //*=================================================
  // To create a new [Meeting] from the old one after destroying it, by
  //  changing some parameters .. DART PREFFERED APPROACH.
  factory MeetMeetingModel.fromOld({
    required dynamic oldMeeting,
    required MeetingStatus newStatus,
    String? title,
    MeetingType? engineType,
    String? jwtToken,
    String? roomTitle,
    String? userEmail,
    String? userName,
    String? password,
    String? link,
    String? inputStartTime,
    String? inputDate,
    String? dataBaseID,
    String? serverURL,
    String? roomID,
    bool? isActive,
    Map<String, dynamic>? settingList,
    List<String>? invitationList,
    String? recordingLink,
  }) =>
      MeetMeetingModel(
        token: jwtToken ?? oldMeeting.token,
        domain: serverURL ?? oldMeeting.domain,
        meetingStatus: newStatus,
        engineType: engineType ?? oldMeeting.engineType,
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
        userEmail: userEmail ?? oldMeeting.userEmail,
        userName: userName ?? oldMeeting.userName,
        isActive: isActive ?? oldMeeting.isActive,
      );
  //*=================================================
  factory MeetMeetingModel.fromJson(Map<String, dynamic> jsonMeeting) =>
      MeetMeetingModel(
        // used
        meetingTitle: jsonMeeting['meeting']['title'],
        meetingStatus:
            getMeetingStatus(jsonMeeting['meeting']['meeting_status']),
        meetingDate: jsonMeeting['meeting']['meeting_date'],
        meetingTime: jsonMeeting['meeting']['meeting_time'],
        meetingDataBaseID: jsonMeeting['meeting']['name'],
        roomTitle: jsonMeeting['meeting']['room_name'],
        roomID: jsonMeeting['meeting']['room_id'],
        settingList: extractSettings(
          settings: jsonMeeting['tool_data']['options']['configOverwrite'],
          shareLink: jsonMeeting['meeting']['meeting_url'],
          meetingID: jsonMeeting['meeting']['name'],
        ),
        domain: checkmeetingDomain(jsonMeeting['tool_data']['domain']),
        invitationList: extractContacts(jsonMeeting['meeting']['invitations']),
        link: jsonMeeting['meeting']['meeting_url'] ?? '',
        // not used
        ownerEmail: jsonMeeting['meeting']['owner'],
        meetingPassword: jsonMeeting['meeting']['password'],
        recordingLink: jsonMeeting['meeting']['recording_url'] ?? '',

        token: jsonMeeting['tool_data']['options']['jwt'],
        userName: jsonMeeting['tool_data']['options']['userInfo']
            ['displayName'],
        userEmail: jsonMeeting['tool_data']['options']['userInfo']['email'],
        engineType: MeetingType.meet,
      );
  //*=================================================
  factory MeetMeetingModel.fromJsonInUpComing(
          Map<String, dynamic> jsonMeeting) =>
      MeetMeetingModel(
        // used
        meetingTitle: jsonMeeting['title'],
        meetingStatus: getMeetingStatus(jsonMeeting['meeting_status'] ?? ''),
        meetingDate: jsonMeeting['meeting_date'],
        meetingTime: jsonMeeting['meeting_time'],
        meetingDataBaseID: jsonMeeting['name'],
        isActive: jsonMeeting['active'] == 1 ? true : false,
        roomTitle: jsonMeeting['room_name'],
        roomID: jsonMeeting['room_id'],
        userEmail: jsonMeeting['email'],
        userName: jsonMeeting['displayName'],

        // settingList: extractSettings(
        //   settings: jsonMeeting['tool_data']['options']['configOverwrite'],
        //   shareLink: jsonMeeting['meeting_url'],
        //   meetingID: jsonMeeting['name'],
        // ),
        domain: checkmeetingDomain(jsonMeeting['domain']),
        invitationList: extractContacts(jsonMeeting['invitations']),
        link: jsonMeeting['meeting_url'] ?? '',
        // not used
        ownerEmail: jsonMeeting['owner'],
        meetingPassword: jsonMeeting['password'],
        recordingLink: jsonMeeting['recording_url'] ?? '',

        token: '',
        engineType: MeetingType.meet,
      );
  //*=================================================
  factory MeetMeetingModel.fromTemplate(
    MeetingTemplate template, {
    Map<String, dynamic>? settingList,
  }) =>
      MeetMeetingModel(
        token: template.jwtToken,
        domain: template.domain,
        meetingTitle: template.title,
        engineType: template.engineType,
        meetingStatus: getMeetingStatus(template.isScheduled.toString()),
        meetingDataBaseID: template.id,
        meetingDate: template.date,
        meetingTime: template.time,
        link: template.link,
        roomID: template.roomID,
        roomTitle: template.roomTitle,
        meetingPassword: template.password,
        settingList: settingList,
      );
  //*=================================================
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // used
    data['title'] = meetingTitle;
    data['domain'] = domain;
    data['jwt'] = token;
    data['engineType'] = engineType;
    data['meeting_status'] = meetingStatus.statusString;
    data['meeting_date'] = meetingDate;
    data['meeting_time'] = meetingTime;
    data['meeting_url'] = link;
    data['room_name'] = roomTitle;
    data['name'] = meetingDataBaseID;
    data['room_id'] = roomID;
    data['engine_type'] = MeetingType.meet;
    data['settings'] = settingList;

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
  static String checkmeetingDomain(String? domain) {
    if (domain == null) return '';
    if (domain.startsWith('https://')) {
      return domain;
    } else {
      return 'https://$domain';
    }
  }

  //*===========================================================================
  static Map<String, dynamic>? extractSettings(
      {required settings, required shareLink, required meetingID}) {
    settings.addAll({'meeting-id': meetingID, 'share-link': shareLink});
    if (Platform.isIOS) {
      settings.addAll({'pip.enabled': false});
    }
    return settings;
  }

  //*===========================================================================
  @override
  List<Object?> get props => [
        meetingDataBaseID,
      ];
  //*===========================================================================
  //*===========================================================================
}
