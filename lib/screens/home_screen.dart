import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../config/app_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LatLng> _boundaryPoints = [];
  bool _showBoundary = true;

  @override
  void initState() {
    super.initState();
    _loadBoundary();
  }

  Future<void> _loadBoundary() async {
    final raw = await rootBundle.loadString('assets/boundary.geojson');
    final data = json.decode(raw);

    List coords = [];
    if (data['type'] == 'FeatureCollection') {
      coords = data['features'][0]['geometry']['coordinates'][0];
    } else if (data['type'] == 'Feature') {
      coords = data['geometry']['coordinates'][0];
    } else {
      coords = data['coordinates'][0];
    }

    setState(() {
      // GeoJSON is [lng, lat] — flip to LatLng(lat, lng)
      _boundaryPoints = coords
          .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landroid'),
        actions: [
          IconButton(
            icon: Icon(_showBoundary ? Icons.layers : Icons.layers_outlined),
            onPressed: () => setState(() => _showBoundary = !_showBoundary),
            tooltip: 'Toggle boundary',
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(AppConfig.centroidLat, AppConfig.centroidLng),
          initialZoom: 16,
        ),
        children: [
          // Satellite base layer
          TileLayer(
            urlTemplate:
                'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            userAgentPackageName: 'com.birdscale.landroid',
          ),

          // Boundary overlay
          if (_showBoundary && _boundaryPoints.isNotEmpty)
            PolygonLayer(
              polygons: [
                Polygon(
                  points: _boundaryPoints,
                  color: Colors.green.withOpacity(0.2),
                  borderColor: Colors.greenAccent,
                  borderStrokeWidth: 2.5,
                ),
              ],
            ),
        ],
      ),
    );
  }
}