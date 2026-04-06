import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/app_config.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> _boundaryPoints = [];
  bool _showBoundary = true;
  bool _showSatellite = true;
  String _statusMessage = 'Loading boundary...';

  @override
  void initState() {
    super.initState();
    _loadBoundary();
  }

Future<void> _loadBoundary() async {
  try {
    final raw = await rootBundle.loadString('assets/boundary.geojson');
    final data = json.decode(raw);

    List coords = [];
    String geomType = '';

    Map<String, dynamic> geometry;
    if (data['type'] == 'FeatureCollection') {
      geometry = data['features'][0]['geometry'];
    } else if (data['type'] == 'Feature') {
      geometry = data['geometry'];
    } else {
      geometry = data;
    }

    geomType = geometry['type'];

    switch (geomType) {
      case 'Polygon':
        coords = geometry['coordinates'][0];
        break;
      case 'MultiPolygon':
        coords = geometry['coordinates'][0][0];
        break;
      case 'LineString':
        coords = geometry['coordinates'];
        break;
      case 'MultiLineString':
        coords = geometry['coordinates'][0];
        break;
      default:
        throw Exception('Unsupported geometry: $geomType');
    }

    if (coords.isEmpty) throw Exception('Empty coordinates');

    // Validate WGS84 range
    final points = coords.map<LatLng>((c) {
      final lat = (c[1] as num).toDouble();
      final lng = (c[0] as num).toDouble();
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        throw Exception('Coordinates are UTM meters, not WGS84. Run extract_coords.py');
      }
      return LatLng(lat, lng);
    }).toList();

    setState(() {
      _boundaryPoints = points;
      _statusMessage = 'Parcel loaded — $geomType, ${points.length} points';
    });
  } catch (e) {
    setState(() {
      _statusMessage = 'Error: $e';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landroid'),
        actions: [
          // Satellite toggle
          IconButton(
            icon: Icon(
              _showSatellite ? Icons.satellite_alt : Icons.map,
              color: _showSatellite ? Colors.greenAccent : Colors.grey,
            ),
            tooltip: 'Toggle satellite layer',
            onPressed: () => setState(() => _showSatellite = !_showSatellite),
          ),
          // Boundary toggle
          IconButton(
            icon: Icon(
              _showBoundary ? Icons.layers : Icons.layers_outlined,
              color: _showBoundary ? Colors.greenAccent : Colors.grey,
            ),
            tooltip: 'Toggle boundary',
            onPressed: () => setState(() => _showBoundary = !_showBoundary),
          ),
        ],
      ),

      body: Stack(
        children: [
          // ── MAP ──────────────────────────────────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                AppConfig.centroidLat,
                AppConfig.centroidLng,
              ),
              initialZoom: 16,
              minZoom: 10,
              maxZoom: 20,
            ),
            children: [
              // Base layer — satellite or street map
              if (_showSatellite)
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.birdscale.landroid',
                )
              else
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.birdscale.landroid',
                ),

              // Boundary polygon
              if (_showBoundary && _boundaryPoints.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _boundaryPoints,
                      color: const Color(0xFF4CAF50).withOpacity(0.18),
                      borderColor: Colors.greenAccent,
                      borderStrokeWidth: 2.5,
                    ),
                  ],
                ),

              if (_showBoundary && _boundaryPoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [..._boundaryPoints, _boundaryPoints.first],
                      color: Colors.greenAccent,
                      strokeWidth: 2.5,
                    ),
                  ],
                ),

              // Boundary corner markers
              if (_showBoundary && _boundaryPoints.isNotEmpty)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        AppConfig.centroidLat,
                        AppConfig.centroidLng,
                      ),
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.location_on,
                            color: Colors.black, size: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ── STATUS BAR ───────────────────────────────────────
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xDD1E1E1E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusMessage,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── BOTTOM SHEET TRIGGER ─────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showParcelInfo,
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Parcel Info'),
      ),
    );
  }

  void _showParcelInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Parcel Details',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _infoRow('Centroid Lat', AppConfig.centroidLat.toStringAsFixed(6)),
            _infoRow('Centroid Lng', AppConfig.centroidLng.toStringAsFixed(6)),
            _infoRow('Boundary Points', '${_boundaryPoints.length}'),
            _infoRow('Status', _statusMessage),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}