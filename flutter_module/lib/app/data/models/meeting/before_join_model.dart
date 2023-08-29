import 'package:equatable/equatable.dart';
import '../../enums/meeting_status.dart';
import '../../enums/meeting_type.dart';

class BeforeJoinModel extends Equatable {
  //*================================ Parameters ===============================

  final String role;
  final MeetingType engineType;
  final MeetingStatus meetingStatus;
  final bool isWaitingRoom;
  final bool isJoinBeforeModerator;

  //*================================ Constructor ==============================
  const BeforeJoinModel({
    required this.engineType,
    required this.role,
    required this.meetingStatus,
    required this.isWaitingRoom,
    required this.isJoinBeforeModerator,
  });
  //*================================= Methods =================================
  factory BeforeJoinModel.fromJson(Map<String, dynamic> jsonMeeting) =>
      BeforeJoinModel(
        engineType: getMeetingType(jsonMeeting['engine_type']),
        role: jsonMeeting['role'],
        meetingStatus: getMeetingStatus(jsonMeeting['meeting_status']),
        isJoinBeforeModerator: jsonMeeting['room_settings']
                    ['AllowParticipantJoinBeforeModerator'] ==
                0
            ? false
            : true,
        isWaitingRoom:
            jsonMeeting['room_settings']['WaitingRoom'] == 0 ? false : true,
      );

  //*==================================
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['engine_type'] = engineType;
    data['role'] = role;
    data['meeting_status'] = meetingStatus.statusString;
    return data;
  }

  //*==================================
  static MeetingStatus getMeetingStatus(String status) {
    switch (status) {
      case 'Not Started':
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
  //*==================================

  static MeetingType getMeetingType(String? engineType) {
    switch (engineType) {
      case 'Meet':
        return MeetingType.meet;
      case 'Classroom':
        return MeetingType.classroom;

      default:
        return MeetingType.classroom;
    }
  }
  //*===========================================================================

  @override
  List<Object?> get props => [
        engineType,
        role,
        meetingStatus,
      ];
}
