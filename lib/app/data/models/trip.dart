import 'package:hive/hive.dart';
import 'destination.dart';
import 'place.dart';
import 'weather.dart';

part 'trip.g.dart';

/// Trip Model - Represents a saved travel itinerary
@HiveType(typeId: 0)
class Trip extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String destinationName;

  @HiveField(2)
  final String destinationCountry;

  @HiveField(3)
  final double lat;

  @HiveField(4)
  final double lon;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime endDate;

  @HiveField(7)
  final List<String> placesJson; // JSON strings of places

  @HiveField(8)
  final String? weatherJson; // JSON string of weather

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final String? imageUrl;

  Trip({
    required this.id,
    required this.destinationName,
    required this.destinationCountry,
    required this.lat,
    required this.lon,
    required this.startDate,
    required this.endDate,
    required this.placesJson,
    this.weatherJson,
    this.notes,
    required this.createdAt,
    this.imageUrl,
  });

  /// Create a new trip from destination and selected places
  factory Trip.create({
    required Destination destination,
    required DateTime startDate,
    required DateTime endDate,
    required List<Place> selectedPlaces,
    Weather? weather,
    String? notes,
    String? imageUrl,
  }) {
    return Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      destinationName: destination.name,
      destinationCountry: destination.country,
      lat: destination.lat,
      lon: destination.lon,
      startDate: startDate,
      endDate: endDate,
      placesJson: selectedPlaces.map((p) => _encodePlace(p)).toList(),
      weatherJson: weather != null ? _encodeWeather(weather) : null,
      notes: notes,
      createdAt: DateTime.now(),
      imageUrl: imageUrl ?? destination.imageUrl,
    );
  }

  /// Get destination object
  Destination get destination => Destination(
    name: destinationName,
    country: destinationCountry,
    lat: lat,
    lon: lon,
    imageUrl: imageUrl,
  );

  /// Get list of places from JSON
  List<Place> get places {
    return placesJson.map((json) => _decodePlace(json)).toList();
  }

  /// Get weather from JSON
  Weather? get weather {
    if (weatherJson == null) return null;
    return _decodeWeather(weatherJson!);
  }

  int get duration => endDate.difference(startDate).inDays + 1;

  int get placesCount => placesJson.length;

  String get title => '$destinationName, $destinationCountry';

  /// Encode place to JSON string
  static String _encodePlace(Place place) {
    final map = place.toJson();
    return '${map['xid']}|${map['name']}|${map['description'] ?? ''}|${map['kinds'] ?? ''}|${map['lat']}|${map['lon']}|${map['rate'] ?? 0}|${map['imageUrl'] ?? ''}|${map['address'] ?? ''}';
  }

  /// Decode place from JSON string
  static Place _decodePlace(String encoded) {
    final parts = encoded.split('|');
    return Place(
      xid: parts[0],
      name: parts[1],
      description: parts[2].isNotEmpty ? parts[2] : null,
      kinds: parts[3].isNotEmpty ? parts[3] : null,
      lat: double.tryParse(parts[4]) ?? 0.0,
      lon: double.tryParse(parts[5]) ?? 0.0,
      rate: int.tryParse(parts[6]),
      imageUrl: parts[7].isNotEmpty ? parts[7] : null,
      address: parts.length > 8 && parts[8].isNotEmpty ? parts[8] : null,
    );
  }

  /// Encode weather to JSON string
  static String _encodeWeather(Weather weather) {
    return '${weather.temperature}|${weather.feelsLike}|${weather.humidity}|${weather.windSpeed}|${weather.condition}|${weather.description}|${weather.icon}|${weather.cityName}';
  }

  /// Decode weather from JSON string
  static Weather _decodeWeather(String encoded) {
    final parts = encoded.split('|');
    return Weather(
      temperature: double.tryParse(parts[0]) ?? 0.0,
      feelsLike: double.tryParse(parts[1]) ?? 0.0,
      humidity: int.tryParse(parts[2]) ?? 0,
      windSpeed: double.tryParse(parts[3]) ?? 0.0,
      condition: parts[4],
      description: parts[5],
      icon: parts[6],
      cityName: parts[7],
    );
  }
}
