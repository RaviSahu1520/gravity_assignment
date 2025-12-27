import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../models/place.dart';
import '../models/weather.dart';
import '../models/trip.dart';
import '../providers/weather_provider.dart';
import '../providers/places_provider.dart';
import '../providers/storage_provider.dart';
import '../../core/constants/api_constants.dart';

class TravelRepository {
  final WeatherProvider _weatherProvider = WeatherProvider();
  final PlacesProvider _placesProvider = PlacesProvider();
  final StorageProvider _storageProvider = StorageProvider();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await _storageProvider.init();
    _isInitialized = true;
  }

  List<Destination> getPopularDestinations() {
    return AppConstants.popularDestinations.map((d) => Destination.fromMap(d)).toList();
  }

  Future<Destination?> searchDestination(String cityName) async {
    final popular = getPopularDestinations();
    final match = popular.where((d) => d.name.toLowerCase() == cityName.toLowerCase());
    if (match.isNotEmpty) return match.first;
    
    final geocoded = await _placesProvider.geocodeCity(cityName);
    if (geocoded != null) return geocoded;
    
    return Destination(name: cityName, country: 'Unknown', lat: 0.0, lon: 0.0);
  }

  Future<Weather?> getWeather(Destination destination) async {
    final weather = await _weatherProvider.getWeatherByCity(destination.name);
    return weather ?? _weatherProvider.getMockWeather(destination.name);
  }

  Future<List<Place>> getPlaces(Destination destination, {String? category}) async {
    if (destination.lat == 0.0 && destination.lon == 0.0) {
      return _placesProvider.getMockPlaces(destination.name);
    }
    
    final places = await _placesProvider.getPlacesByRadius(
      lat: destination.lat,
      lon: destination.lon,
      kinds: category == 'all' ? null : category,
    );
    
    if (places.isEmpty) {
      return _placesProvider.getMockPlaces(destination.name);
    }
    return places;
  }

  Future<void> saveTrip(Trip trip) async => await _storageProvider.saveTrip(trip);
  List<Trip> getSavedTrips() => _storageProvider.getAllTrips();
  Future<void> deleteTrip(String tripId) async => await _storageProvider.deleteTrip(tripId);
  Trip? getTrip(String tripId) => _storageProvider.getTrip(tripId);
  
  bool get isUsingMockData => false;
}
