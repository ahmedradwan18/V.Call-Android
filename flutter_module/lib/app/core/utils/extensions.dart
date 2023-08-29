import 'package:get/route_manager.dart';

extension DoubleHeightFactorExtension on double {
  /// Get the Height Factor of a provided [Decimal Point/Double].
  double get hf => (this * Get.height);
}

extension DoubleWidthFactorExtension on double {
  /// Get the Width Factor of a provided [Decimal Point/Double].
  double get wf => (this * Get.width);
}

extension IntHeightFactorExtension on int {
  /// Get the Height Factor of a provided [Decimal Point/Double].
  int get hf => (this * Get.height).toInt();
}

extension IntWidthFactorExtension on int {
  /// Get the Width Factor of a provided [Decimal Point/Double].
  int get wf => (this * Get.width).toInt();
}
