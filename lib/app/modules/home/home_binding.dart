import 'package:get/get.dart';
import 'home_controller.dart';
import '../../data/repositories/travel_repository.dart';

/// Home Binding - Dependency injection for Home module
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register repository if not already registered
    if (!Get.isRegistered<TravelRepository>()) {
      Get.put(TravelRepository(), permanent: true);
    }
    
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
