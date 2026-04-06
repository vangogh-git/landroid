import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonService {
  static Future<List<LatLng>> loadBoundaryPoints() async {
    final raw = await rootBundle.loadString('assets/boundary_wgs84.geojson');
    final data = jsonDecode(raw);

    final features = data['features'] as List<dynamic>;
    if (features.isEmpty) return [];

    final geometry = features.first['geometry'];
    final coords = geometry['coordinates'];

    return _extractPoints(coords);
  }

  static List<LatLng> _extractPoints(dynamic coordinates) {
    if (coordinates is! List || coordinates.isEmpty) return [];

    final first = coordinates.first;

    // LineString: [ [lng, lat], [lng, lat], ... ]
    if (first is List && first.isNotEmpty && first.first is num) {
      return coordinates.map<LatLng>((p) {
        final lng = (p[0] as num).toDouble();
        final lat = (p[1] as num).toDouble();
        return LatLng(lat, lng);
      }).toList();
    }

    // Polygon: [ [ [lng, lat], ... ] ]
    if (first is List && first.isNotEmpty && first.first is List) {
      return _extractPoints(first);
    }

    return [];
  }
}