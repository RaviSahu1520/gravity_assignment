/// Weather Model - Represents weather information
class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String description;
  final String icon;
  final String cityName;
  final DateTime? sunrise;
  final DateTime? sunset;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.icon,
    required this.cityName,
    this.sunrise,
    this.sunset,
  });

  /// Create from OpenWeatherMap API response
  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final wind = json['wind'] ?? {};
    final weather = (json['weather'] as List?)?.first ?? {};
    final sys = json['sys'] ?? {};

    return Weather(
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      condition: weather['main'] ?? 'Unknown',
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '01d',
      cityName: json['name'] ?? '',
      sunrise: sys['sunrise'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)
          : null,
      sunset: sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)
          : null,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'condition': condition,
      'description': description,
      'icon': icon,
      'cityName': cityName,
      'sunrise': sunrise?.millisecondsSinceEpoch,
      'sunset': sunset?.millisecondsSinceEpoch,
    };
  }

  /// Create from stored JSON
  factory Weather.fromStoredJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature'] ?? 0).toDouble(),
      feelsLike: (json['feelsLike'] ?? 0).toDouble(),
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '01d',
      cityName: json['cityName'] ?? '',
      sunrise: json['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sunrise'])
          : null,
      sunset: json['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sunset'])
          : null,
    );
  }

  /// Get weather icon URL
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  /// Get temperature display string
  String get temperatureDisplay => '${temperature.round()}°C';

  /// Get feels like display string
  String get feelsLikeDisplay => 'Feels like ${feelsLike.round()}°C';

  @override
  String toString() => '$temperatureDisplay - $condition';
}
