import 'package:get/get.dart';

import '../controllers/creation_controller.dart';

class CreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreationController>(
      () => CreationController(),
    );
  }
}
