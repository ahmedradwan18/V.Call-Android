import '../../../core/utils/date_time_utils.dart';
import '../../enums/meeting_type.dart';
import '../room/room_settings_model.dart';

/// Model for a [MeetingTemplate], e.g. used in [createMeetingView]
/// [Properties] are not [Final] as I only need to use it as a temp placeholder
/// for the data the user inputs, then I just send them to the API
// ignore: must_be_immutable
class MeetingTemplate {
  //?=============================== Properties ================================
  String title;
  String password;
  String link;
  String roomID;
  MeetingType engineType;
  String jwtToken;
  String domain;
  bool isActive;

  // the database ID of the meeting being edited
  String id;
  // to use in [Edit Meeting] to create a new meeting with to replace the
  // old one.
  String roomTitle;

  // Null as I want to initialize them with [], but can't do that in the
  // constructor
  /// List of InvitedCOntacts, to be used at [InvitedConatctsScreen]
  /// that's why it's not just [IDs] of each invitedContact
  // List<ContactModel>? invitedContactsList;
  // Big/Small List
  List<RoomSettingsModel>? roomSettingList;
  RoomSettingsModel? settingList;

  // Will be converted [DateTime => String] in the constructor, to be sent
  // directly in the API.
  late String date;
  late String time;
  bool isScheduled;

  //?=============================== Constructor ===============================
  MeetingTemplate({
    this.title = '',
    this.engineType = MeetingType.classroom,
    this.password = '',
    this.roomID = '',
    this.roomTitle = '',
    this.domain = '',
    this.jwtToken = '',
    this.id = '',
    this.link = '',
    DateTime? inputDate,
    DateTime? inputTime,
    this.isScheduled = false,
    this.isActive = true,
    this.settingList,
  }) {
    // Handle the case that the input[date/time] are null.
    date = DateTimeUtils.getStringFromDate(inputDate);
    time = DateTimeUtils.getStringFromTime(inputTime);
    // If [inputTime] is [Null], then it was not enterd by the user, so
    // the meeting is NOT SCHEDUELD
    isScheduled = inputTime != null;
    // initialize the lists
    roomSettingList = [];
  }
  //?================================ Methods ==================================

  /// checks whether or not all the necessary fields of meeting have been
  /// entered and are ready to be sent to the API, this will be used to
  /// determine the state of [Step] in the [Stepper] in [CreateMeetingView]
  /// e.g. editing, completed, etc..
  bool isMeetingInfoFull() {
    return (title.length >= 3);
  }

  List<Map<String, dynamic>> jsonSettings(MeetingType meetingType) {
    late List<Map<String, dynamic>> settings;
    var jsonRoomSettings = roomSettingList!.map(
      (engineSettings) {
        return engineSettings.toJson();
      },
    ).toList();
    for (var element in jsonRoomSettings) {
      if (element['engine'] == engineType) {
        settings = element['settings'];
      }
    }

    return settings;
  }
  //?===========================================================================
  //?===========================================================================
}
