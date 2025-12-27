/// Place Model - Represents a tourist attraction/place
class Place {
  final String xid; // OpenTripMap unique ID
  final String name;
  final String? description;
  final String? kinds; // Categories separated by comma
  final double lat;
  final double lon;
  final int? rate; // Rating 1-7
  final String? imageUrl;
  final String? wikipediaUrl;
  final String? address;
  bool isSelected; // For itinerary selection

  Place({
    required this.xid,
    required this.name,
    this.description,
    this.kinds,
    required this.lat,
    required this.lon,
    this.rate,
    this.imageUrl,
    this.wikipediaUrl,
    this.address,
    this.isSelected = false,
  });

  /// Create from OpenTripMap places list response
  factory Place.fromListJson(Map<String, dynamic> json) {
    final point = json['point'] ?? {};
    return Place(
      xid: json['xid'] ?? '',
      name: json['name'] ?? 'Unknown Place',
      kinds: json['kinds'],
      lat: point['lat']?.toDouble() ?? 0.0,
      lon: point['lon']?.toDouble() ?? 0.0,
      rate: json['rate'],
    );
  }

  /// Create from OpenTripMap place details response
  factory Place.fromDetailsJson(Map<String, dynamic> json) {
    final point = json['point'] ?? {};
    final address = json['address'] ?? {};
    final preview = json['preview'] ?? {};
    
    return Place(
      xid: json['xid'] ?? '',
      name: json['name'] ?? 'Unknown Place',
      description: json['wikipedia_extracts']?['text'],
      kinds: json['kinds'],
      lat: point['lat']?.toDouble() ?? 0.0,
      lon: point['lon']?.toDouble() ?? 0.0,
      rate: json['rate'],
      imageUrl: preview['source'],
      wikipediaUrl: json['wikipedia'],
      address: _formatAddress(address),
    );
  }

  /// Format address from JSON
  static String? _formatAddress(Map<String, dynamic> address) {
    final parts = <String>[];
    if (address['road'] != null) parts.add(address['road']);
    if (address['city'] != null) parts.add(address['city']);
    if (address['country'] != null) parts.add(address['country']);
    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'xid': xid,
      'name': name,
      'description': description,
      'kinds': kinds,
      'lat': lat,
      'lon': lon,
      'rate': rate,
      'imageUrl': imageUrl,
      'wikipediaUrl': wikipediaUrl,
      'address': address,
      'isSelected': isSelected,
    };
  }

  /// Create from stored JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      xid: json['xid'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      kinds: json['kinds'],
      lat: json['lat']?.toDouble() ?? 0.0,
      lon: json['lon']?.toDouble() ?? 0.0,
      rate: json['rate'],
      imageUrl: json['imageUrl'],
      wikipediaUrl: json['wikipediaUrl'],
      address: json['address'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  /// Get primary category from kinds
  String get primaryCategory {
    if (kinds == null || kinds!.isEmpty) return 'other';
    return kinds!.split(',').first.trim();
  }

  /// Get rating display (stars)
  String get ratingDisplay {
    if (rate == null) return '☆☆☆';
    final stars = (rate! / 2).round().clamp(1, 5);
    return '★' * stars + '☆' * (5 - stars);
  }

  @override
  String toString() => name;
}
