import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../services/geojson_service.dart';

class ParcelMapScreen extends StatefulWidget {
  const ParcelMapScreen({super.key});

  @override
  State<ParcelMapScreen> createState() => _ParcelMapScreenState();
}

class _ParcelMapScreenState extends State<ParcelMapScreen> {
  List<LatLng> boundaryPoints = [];
  bool isSatellite = true;

  @override
  void initState() {
    super.initState();
    _loadBoundary();
  }

  Future<void> _loadBoundary() async {
    final points = await GeoJsonService.loadBoundaryPoints();

    if (!mounted) return;
    setState(() {
      boundaryPoints = points;
    });
  }

  LatLng _getCenter() {
    double latSum = 0;
    double lngSum = 0;

    for (final p in boundaryPoints) {
      latSum += p.latitude;
      lngSum += p.longitude;
    }

    return LatLng(
      latSum / boundaryPoints.length,
      lngSum / boundaryPoints.length,
    );
  }

  List<LatLng> _closedPoints() {
    if (boundaryPoints.isEmpty) return [];

    final points = List<LatLng>.from(boundaryPoints);
    if (points.first != points.last) {
      points.add(points.first);
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    if (boundaryPoints.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final center = _getCenter();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcel Map'),
        actions: [
          IconButton(
            icon: Icon(isSatellite ? Icons.map_outlined : Icons.satellite_alt),
            onPressed: () {
              setState(() {
                isSatellite = !isSatellite;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.landroid',
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: _closedPoints(),
                    color: Colors.green.withValues(alpha: 0.28),
                    borderColor: Colors.green.shade800,
                    borderStrokeWidth: 3,
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _closedPoints(),
                    strokeWidth: 3,
                    color: Colors.green.shade900,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 44,
                    height: 44,
                    child: const Icon(
                      Icons.place_rounded,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 18,
            right: 18,
            child: Column(
              children: [
                _smallButton(
                  icon: Icons.layers,
                  onTap: () {
                    setState(() {
                      isSatellite = !isSatellite;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _smallButton(
                  icon: Icons.my_location,
                  onTap: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legend',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.square, color: Colors.green, size: 16),
                      SizedBox(width: 6),
                      Text('Parcel boundary'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_rounded, color: Colors.red, size: 16),
                      SizedBox(width: 6),
                      Text('Center point'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}