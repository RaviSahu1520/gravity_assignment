import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../../core/constants/api_constants.dart';

/// Weather API Provider - Handles OpenWeatherMap API calls
class WeatherProvider {
  /// Get current weather for a city by name
  Future<Weather?> getWeatherByCity(String cityName) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.weatherBaseUrl}/weather?q=$cityName&appid=${ApiConstants.weatherApiKey}&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('Weather API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Weather Provider Error: $e');
      return null;
    }
  }

  /// Get current weather by coordinates
  Future<Weather?> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.weatherBaseUrl}/weather?lat=$lat&lon=$lon&appid=${ApiConstants.weatherApiKey}&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('Weather API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Weather Provider Error: $e');
      return null;
    }
  }

  /// Get mock weather data for demo (when API fails)
  Weather getMockWeather(String cityName) {
    return Weather(
      temperature: 25.0,
      feelsLike: 27.0,
      humidity: 65,
      windSpeed: 12.5,
      condition: 'Clear',
      description: 'clear sky',
      icon: '01d',
      cityName: cityName,
      sunrise: DateTime.now().subtract(const Duration(hours: 6)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
    );
  }
}
