import 'package:get/get.dart';

import '../controllers/vlc_controller.dart';

class VlcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VlcController>(
      () => VlcController(),
    );
  }
}
