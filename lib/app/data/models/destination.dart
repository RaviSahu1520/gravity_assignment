/// Destination Model - Represents a travel destination/city
class Destination {
  final String name;
  final String country;
  final double lat;
  final double lon;
  final String? imageUrl;
  final String? description;

  Destination({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.imageUrl,
    this.description,
  });

  /// Create from JSON (OpenTripMap geocoding response)
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      lat: json['lat']?.toDouble() ?? 0.0,
      lon: json['lon']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  /// Create from popular destinations constant
  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      lon: map['lon']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'lat': lat,
      'lon': lon,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  /// Get display name with country
  String get displayName => '$name, $country';

  @override
  String toString() => displayName;
}
