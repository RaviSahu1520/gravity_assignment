import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/destination.dart';
import '../../data/models/place.dart';
import '../../data/models/weather.dart';
import '../../data/models/trip.dart';
import '../../data/repositories/travel_repository.dart';
import '../../routes/app_routes.dart';
import '../../core/theme/app_theme.dart';

class ItineraryController extends GetxController {
  late TravelRepository _repo;
  late Destination destination;
  late List<Place> selectedPlaces;
  Weather? weather;

  final orderedPlaces = <Place>[].obs;
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().add(const Duration(days: 3)).obs;
  final tripNotes = ''.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<TravelRepository>();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      destination = args['destination'];
      selectedPlaces = args['places'];
      weather = args['weather'];
      orderedPlaces.value = List.from(selectedPlaces);
    }
  }

  void reorderPlaces(int oldIdx, int newIdx) {
    if (newIdx > oldIdx) newIdx--;
    final item = orderedPlaces.removeAt(oldIdx);
    orderedPlaces.insert(newIdx, item);
  }

  void removePlace(int idx) => orderedPlaces.removeAt(idx);

  Future<void> pickStartDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: startDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      startDate.value = picked;
      if (endDate.value.isBefore(picked)) {
        endDate.value = picked.add(Duration(days: 1));
      }
    }
  }

  Future<void> pickEndDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: endDate.value,
      firstDate: startDate.value,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) endDate.value = picked;
  }

  int get tripDuration => endDate.value.difference(startDate.value).inDays + 1;

  Future<void> saveTrip() async {
    if (orderedPlaces.isEmpty) {
      Get.snackbar('Error', 'Add at least one place', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving.value = true;
    try {
      final trip = Trip.create(
        destination: destination,
        startDate: startDate.value,
        endDate: endDate.value,
        selectedPlaces: orderedPlaces.toList(),
        weather: weather,
        notes: tripNotes.value.isNotEmpty ? tripNotes.value : null,
      );
      await _repo.saveTrip(trip);
      Get.snackbar('Saved!', 'Trip saved successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.successColor, colorText: Colors.white);
      await Future.delayed(Duration(milliseconds: 500));
      Get.offAllNamed(Routes.home);
      Get.toNamed(Routes.savedTrips);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  void updateNotes(String val) => tripNotes.value = val;
}
