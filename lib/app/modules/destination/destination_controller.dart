import 'package:get/get.dart';
import '../../data/models/destination.dart';
import '../../data/models/place.dart';
import '../../data/models/weather.dart';
import '../../data/repositories/travel_repository.dart';
import '../../routes/app_routes.dart';

class DestinationController extends GetxController {
  late TravelRepository _repo;
  late Destination destination;
  
  final weather = Rx<Weather?>(null);
  final places = <Place>[].obs;
  final selectedPlaces = <Place>[].obs;
  final isLoadingWeather = true.obs;
  final isLoadingPlaces = true.obs;
  final selectedCategory = 'all'.obs;

  final categories = [
    {'key': 'all', 'label': 'All', 'icon': '🌟'},
    {'key': 'cultural', 'label': 'Culture', 'icon': '🏛️'},
    {'key': 'historic', 'label': 'Historic', 'icon': '🏰'},
    {'key': 'natural', 'label': 'Nature', 'icon': '🌲'},
    {'key': 'amusements', 'label': 'Fun', 'icon': '🎢'},
    {'key': 'foods', 'label': 'Food', 'icon': '🍽️'},
  ];

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<TravelRepository>();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args?['destination'] != null) {
      destination = args!['destination'] as Destination;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Future.wait([_loadWeather(), _loadPlaces()]);
  }

  Future<void> _loadWeather() async {
    isLoadingWeather.value = true;
    weather.value = await _repo.getWeather(destination);
    isLoadingWeather.value = false;
  }

  Future<void> _loadPlaces({String? cat}) async {
    isLoadingPlaces.value = true;
    final kind = (cat == 'all' || cat == null) ? null : cat;
    places.value = await _repo.getPlaces(destination, category: kind);
    for (var p in places) {
      p.isSelected = selectedPlaces.any((s) => s.xid == p.xid);
    }
    isLoadingPlaces.value = false;
  }

  void filterByCategory(String cat) {
    if (selectedCategory.value == cat) return;
    selectedCategory.value = cat;
    _loadPlaces(cat: cat);
  }

  void togglePlaceSelection(Place place) {
    final idx = places.indexWhere((p) => p.xid == place.xid);
    if (idx == -1) return;
    
    places[idx].isSelected = !places[idx].isSelected;
    places.refresh();
    
    if (places[idx].isSelected) {
      selectedPlaces.add(places[idx]);
    } else {
      selectedPlaces.removeWhere((p) => p.xid == place.xid);
    }
  }

  void goToItinerary() {
    if (selectedPlaces.isEmpty) {
      Get.snackbar('Select Places', 'Pick at least one place first', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.toNamed(Routes.itinerary, arguments: {
      'destination': destination,
      'places': selectedPlaces.toList(),
      'weather': weather.value,
    });
  }

  int get selectedCount => selectedPlaces.length;
}
