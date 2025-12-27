import 'api_secrets.dart';

class ApiConstants {
  static const weatherApiKey = ApiSecrets.weatherApiKey;
  static const weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  static const placesApiKey = ApiSecrets.placesApiKey;
  static const placesBaseUrl = 'https://api.geoapify.com/v2/places';
  
  static const defaultRadius = 5000;
  static const placesLimit = 20;
  
  static const defaultCityImage = 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800';
  static const defaultPlaceImage = 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400';
}

class AppConstants {
  static const appName = 'Travel Planner';
  static const hiveBoxName = 'trips_box';
  
  static const popularDestinations = [
    {'name': 'Gwalior', 'country': 'India', 'lat': 26.2183, 'lon': 78.1828},
    {'name': 'Indore', 'country': 'India', 'lat': 22.7196, 'lon': 75.8577},
    {'name': 'Bhopal', 'country': 'India', 'lat': 23.2599, 'lon': 77.4126},
    {'name': 'Jaipur', 'country': 'India', 'lat': 26.9124, 'lon': 75.7873},
    {'name': 'Udaipur', 'country': 'India', 'lat': 24.5854, 'lon': 73.7125},
    {'name': 'Varanasi', 'country': 'India', 'lat': 25.3176, 'lon': 82.9739},
  ];
}
