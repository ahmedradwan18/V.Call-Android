import 'meeting/classroom_meeting_model.dart';

class VlcViewArugumets {
  //*================================ Parameters ===============================
  final String url;
  // NUllable, as I may be just a viewer/attendee of a meeting
  final ClassroomMeetingModel? meeting;
  //*================================ Constructor ==============================
  const VlcViewArugumets({
    required this.url,
    this.meeting,
  });
  //*================================= Methods =================================

  //*===========================================================================
}
