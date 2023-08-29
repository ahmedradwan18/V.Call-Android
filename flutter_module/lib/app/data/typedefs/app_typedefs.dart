import '../models/creation/meeting_setting_model.dart';

typedef FutureVoidCallback = Future<void> Function();

typedef OnToggleMeetingSetting = Future<void> Function(
    MeetingSettingModel setting);

typedef OnCheckboxChanged = void Function({
  required bool newValue,
  required int index,
});
