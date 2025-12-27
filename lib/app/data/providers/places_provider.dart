import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../models/destination.dart';
import '../../core/constants/api_constants.dart';

class PlacesProvider {
  
  Future<List<Place>> getPlacesByRadius({
    required double lat,
    required double lon,
    String? kinds,
  }) async {
    try {
      final category = _mapCategory(kinds);
      final url = Uri.parse(
        '${ApiConstants.placesBaseUrl}?categories=$category&filter=circle:$lon,$lat,${ApiConstants.defaultRadius}&limit=${ApiConstants.placesLimit}&apiKey=${ApiConstants.placesApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List? ?? [];
        return features.map((f) => _parsePlace(f)).toList();
      }
    } catch (e) {
      print('Places API error: $e');
    }
    return [];
  }

  Place _parsePlace(Map<String, dynamic> feature) {
    final props = feature['properties'] ?? {};
    final geo = feature['geometry'] ?? {};
    final coords = geo['coordinates'] as List? ?? [0.0, 0.0];
    
    return Place(
      xid: props['place_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: props['name'] ?? props['address_line1'] ?? 'Unknown Place',
      description: props['address_line2'],
      kinds: props['categories']?.join(','),
      lat: coords.length > 1 ? (coords[1] as num).toDouble() : 0.0,
      lon: coords.length > 0 ? (coords[0] as num).toDouble() : 0.0,
      rate: null,
      imageUrl: null,
      address: props['formatted'],
    );
  }

  String _mapCategory(String? kind) {
    final mapping = {
      'cultural': 'entertainment.culture',
      'historic': 'heritage',
      'natural': 'natural',
      'amusements': 'entertainment',
      'foods': 'catering',
    };
    return mapping[kind] ?? 'tourism.attraction,tourism.sights';
  }

  Future<Destination?> geocodeCity(String cityName) async {
    try {
      final url = Uri.parse(
        'https://api.geoapify.com/v1/geocode/search?text=$cityName&type=city&limit=1&apiKey=${ApiConstants.placesApiKey}',
      );
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List? ?? [];
        if (features.isNotEmpty) {
          final props = features[0]['properties'];
          final coords = features[0]['geometry']['coordinates'];
          return Destination(
            name: props['city'] ?? props['name'] ?? cityName,
            country: props['country'] ?? '',
            lat: coords[1].toDouble(),
            lon: coords[0].toDouble(),
          );
        }
      }
    } catch (e) {
      print('Geocode error: $e');
    }
    return null;
  }

  List<Place> getMockPlaces(String cityName) {
    final mockData = {
      'Paris': [
        Place(xid: 'p1', name: 'Eiffel Tower', kinds: 'cultural', lat: 48.8584, lon: 2.2945, rate: 7),
        Place(xid: 'p2', name: 'Louvre Museum', kinds: 'cultural', lat: 48.8606, lon: 2.3376, rate: 7),
        Place(xid: 'p3', name: 'Notre-Dame', kinds: 'historic', lat: 48.8530, lon: 2.3499, rate: 6),
        Place(xid: 'p4', name: 'Arc de Triomphe', kinds: 'historic', lat: 48.8738, lon: 2.2950, rate: 6),
      ],
      'Tokyo': [
        Place(xid: 't1', name: 'Tokyo Tower', kinds: 'cultural', lat: 35.6586, lon: 139.7454, rate: 6),
        Place(xid: 't2', name: 'Senso-ji Temple', kinds: 'historic', lat: 35.7148, lon: 139.7967, rate: 7),
        Place(xid: 't3', name: 'Shibuya Crossing', kinds: 'cultural', lat: 35.6595, lon: 139.7004, rate: 5),
      ],
    };
    return mockData[cityName] ?? [
      Place(xid: 'd1', name: 'City Center', kinds: 'cultural', lat: 0, lon: 0, rate: 5),
      Place(xid: 'd2', name: 'Main Square', kinds: 'historic', lat: 0, lon: 0, rate: 5),
      Place(xid: 'd3', name: 'Local Market', kinds: 'foods', lat: 0, lon: 0, rate: 4),
    ];
  }
}
