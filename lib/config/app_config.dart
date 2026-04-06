import 'package:flutter_dotenv/flutter_dotenv.dart';

// NOTE: run reproject_boundary.py then extract_coords.py to update these values
class AppConfig {
  static double get centroidLat =>
      double.tryParse(dotenv.env['CENTROID_LAT'] ?? '') ?? 0.0;

  static double get centroidLng =>
      double.tryParse(dotenv.env['CENTROID_LNG'] ?? '') ?? 0.0;

  static double get bboxMinLon =>
      double.tryParse(dotenv.env['BBOX_MIN_LON'] ?? '') ?? 0.0;

  static double get bboxMinLat =>
      double.tryParse(dotenv.env['BBOX_MIN_LAT'] ?? '') ?? 0.0;

  static double get bboxMaxLon =>
      double.tryParse(dotenv.env['BBOX_MAX_LON'] ?? '') ?? 0.0;

  static double get bboxMaxLat =>
      double.tryParse(dotenv.env['BBOX_MAX_LAT'] ?? '') ?? 0.0;

  static String get soilGridsApi => dotenv.env['SOILGRIDS_API'] ?? '';

  static String get osmNominatim => dotenv.env['OSM_NOMINATIM'] ?? '';

  static String get osmOverpass => dotenv.env['OSM_OVERPASS'] ?? '';

  static String get planetaryComputerStac =>
      dotenv.env['PLANETARY_COMPUTER_STAC'] ?? '';
}
