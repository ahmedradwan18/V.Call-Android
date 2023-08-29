import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// To avoid memorizing the texts .. and for future states.
enum CreationStates {
  create,
  edit,
}

/// To avoid memorizing the texts .. and for future states.
extension CreationStatesExtension on CreationStates {
  String get pageTitle {
    switch (this) {
      case CreationStates.create:
        return 'create_new_meeting'.tr;
      case CreationStates.edit:
        return 'edit_meeting'.tr;
      default:
        return 'create_new_meeting'.tr;
    }
  }

  String buttonTitle(bool isScheduled) {
    switch (this) {
      case CreationStates.create:
        return isScheduled ? 'schedule_meeting'.tr : 'create_meeting'.tr;
      case CreationStates.edit:
        return 'edit_meeting'.tr;
      default:
        return 'create_meeting'.tr;
    }
  }
}
