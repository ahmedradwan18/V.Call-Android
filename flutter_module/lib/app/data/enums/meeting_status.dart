enum MeetingStatus {
  upcoming,
  log,
  started,
}

extension MeetingStatusExtension on MeetingStatus {
  String get statusString {
    switch (this) {
      case MeetingStatus.upcoming:
        return 'Not Started';
      case MeetingStatus.started:
        return 'Started';
      case MeetingStatus.log:
        return 'Ended';
      default:
        return 'Not Started';
    }
  }
}
