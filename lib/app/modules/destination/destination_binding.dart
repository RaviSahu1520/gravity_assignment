import 'package:get/get.dart';
import 'destination_controller.dart';

/// Destination Binding - Dependency injection for Destination module
class DestinationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DestinationController>(() => DestinationController());
  }
}
