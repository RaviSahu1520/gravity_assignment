import 'package:get/get.dart';
import '../../data/models/destination.dart';
import '../../data/repositories/travel_repository.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  late TravelRepository _repo;

  final popularDestinations = <Destination>[].obs;
  final recentSearches = <String>[].obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  final errorMsg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<TravelRepository>();
    popularDestinations.value = _repo.getPopularDestinations();
  }

  Future<void> searchDestination(String query) async {
    if (query.trim().isEmpty) return;
    isSearching.value = true;
    errorMsg.value = '';

    try {
      final dest = await _repo.searchDestination(query);
      if (dest != null) {
        if (!recentSearches.contains(query)) {
          recentSearches.insert(0, query);
          if (recentSearches.length > 5) recentSearches.removeLast();
        }
        navigateToDestination(dest);
      } else {
        errorMsg.value = 'City not found';
      }
    } catch (e) {
      errorMsg.value = 'Something went wrong';
    } finally {
      isSearching.value = false;
    }
  }

  void navigateToDestination(Destination dest) {
    Get.toNamed(Routes.destination, arguments: {'destination': dest});
  }

  void navigateToSavedTrips() => Get.toNamed(Routes.savedTrips);

  void clearSearch() {
    searchQuery.value = '';
    errorMsg.value = '';
  }

  bool get isUsingMockData => _repo.isUsingMockData;
}
