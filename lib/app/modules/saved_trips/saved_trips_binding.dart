import 'package:get/get.dart';
import 'saved_trips_controller.dart';

/// Saved Trips Binding - Dependency injection for Saved Trips module
class SavedTripsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedTripsController>(() => SavedTripsController());
  }
}
