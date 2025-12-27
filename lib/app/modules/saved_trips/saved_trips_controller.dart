import 'package:get/get.dart';
import '../../data/models/trip.dart';
import '../../data/repositories/travel_repository.dart';

class SavedTripsController extends GetxController {
  late TravelRepository _repo;
  final trips = <Trip>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<TravelRepository>();
    loadTrips();
  }

  void loadTrips() {
    isLoading.value = true;
    trips.value = _repo.getSavedTrips();
    isLoading.value = false;
  }

  Future<void> deleteTrip(String id) async {
    await _repo.deleteTrip(id);
    trips.removeWhere((t) => t.id == id);
    Get.snackbar('Deleted', 'Trip removed', snackPosition: SnackPosition.BOTTOM);
  }

  void confirmDelete(Trip trip) {
    Get.defaultDialog(
      title: 'Delete?',
      middleText: 'Remove trip to ${trip.destinationName}?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        Get.back();
        deleteTrip(trip.id);
      },
    );
  }
}
