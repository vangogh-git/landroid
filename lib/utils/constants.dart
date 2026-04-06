class AppConstants {
  // Your parcel centroid from boundary_wgs84.geojson
  static const double centroidLat = 10.428859;
  static const double centroidLng = 77.304527;

  static const double bboxMinLon = 77.303500;
  static const double bboxMinLat = 10.427800;
  static const double bboxMaxLon = 77.305500;
  static const double bboxMaxLat = 10.430000;

  // API endpoints
  static const String soilGridsApi =
      'https://rest.isric.org/soilgrids/v2.0/properties/query';
  static const String osmNominatim =
      'https://nominatim.openstreetmap.org/reverse';
  static const String planetaryStac =
      'https://planetarycomputer.microsoft.com/api/stac/v1';
}