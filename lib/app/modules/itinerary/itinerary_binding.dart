import 'package:get/get.dart';
import 'itinerary_controller.dart';

/// Itinerary Binding - Dependency injection for Itinerary module
class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItineraryController>(() => ItineraryController());
  }
}
