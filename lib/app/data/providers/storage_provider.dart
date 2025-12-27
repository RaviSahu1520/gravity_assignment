import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart';
import '../../core/constants/api_constants.dart';

/// Storage Provider - Handles local data persistence with Hive
class StorageProvider {
  late Box<Trip> _tripsBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TripAdapter());
    _tripsBox = await Hive.openBox<Trip>(AppConstants.hiveBoxName);
  }

  /// Get all saved trips
  List<Trip> getAllTrips() {
    return _tripsBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
  }

  /// Save a new trip
  Future<void> saveTrip(Trip trip) async {
    await _tripsBox.put(trip.id, trip);
  }

  /// Delete a trip by ID
  Future<void> deleteTrip(String tripId) async {
    await _tripsBox.delete(tripId);
  }

  /// Get a trip by ID
  Trip? getTrip(String tripId) {
    return _tripsBox.get(tripId);
  }

  /// Update an existing trip
  Future<void> updateTrip(Trip trip) async {
    await _tripsBox.put(trip.id, trip);
  }

  /// Clear all trips
  Future<void> clearAllTrips() async {
    await _tripsBox.clear();
  }

  /// Get trips count
  int get tripsCount => _tripsBox.length;

  /// Check if a trip exists
  bool tripExists(String tripId) {
    return _tripsBox.containsKey(tripId);
  }
}
