enum MeetingType {
  classroom,
  meet;

  String get label {
    switch (this) {
      case MeetingType.classroom:
        return 'ClassRoom';
      case MeetingType.meet:
        return 'Meet';
      default:
        return 'ClassRoom';
    }
  }

  String get name {
    switch (this) {
      case MeetingType.classroom:
        return 'Class Room';
      case MeetingType.meet:
        return 'Meeting Room';
      default:
        return 'ClassRoom';
    }
  }
}
