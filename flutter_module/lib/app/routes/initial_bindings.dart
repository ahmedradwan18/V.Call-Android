import 'package:get/instance_manager.dart';

import '../modules/creation/controllers/creation_controller.dart';
import '../modules/meetings/controllers/meetings_controller.dart';
import '../modules/room/controllers/rooms_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingsController>(
      () => MeetingsController(),
      fenix: true,
    );

    Get.lazyPut<RoomsController>(
      () => RoomsController(),
      fenix: true,
    );
    Get.lazyPut<CreationController>(
      () => CreationController(),
      fenix: true,
    );
  }
}
