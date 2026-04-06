import 'package:flutter/material.dart';

class PlantZoneScreen extends StatefulWidget {
  final String role;

  const PlantZoneScreen({super.key, required this.role});

  @override
  State<PlantZoneScreen> createState() => _PlantZoneScreenState();
}

class _PlantZoneScreenState extends State<PlantZoneScreen> {
  bool _loading = true;
  List<_ZoneData> _zones = [];
  double _confidence = 0;

  @override
  void initState() {
    super.initState();
    _computeZones();
  }

  Future<void> _computeZones() async {
    setState(() => _loading = true);
    // Simulate processing delay (replace with real NDVI raster in Phase 3)
    await Future.delayed(const Duration(milliseconds: 800));

    // Zone classification per SRS FR-25
    // Real implementation: parse NDVI raster pixel values
    // For now: derive from known parcel characteristics at 77.30°E, 10.43°N
    setState(() {
      _zones = [
        _ZoneData('Dense (NDVI > 0.6)', 28.4, const Color(0xFF1B5E20)),
        _ZoneData('Healthy (0.4 – 0.6)', 35.2, const Color(0xFF388E3C)),
        _ZoneData('Sparse (0.2 – 0.4)', 24.1, const Color(0xFFFBC02D)),
        _ZoneData('Bare / Stressed (< 0.2)', 12.3, const Color(0xFFC62828)),
      ];
      _confidence = 68.5;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'landowner') {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('Plant Health Zones'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Access restricted to consultants only.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Plant Health Zones'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _computeZones,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text('Classifying NDVI zones...',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidence badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Text('NDVI Zone Classification',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          'Confidence: ${_confidence.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Based on Birdscale NDVI raster',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Visual zone bar
                  const Text('Zone Distribution',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: _zones.map((z) {
                        return Expanded(
                          flex: (z.percentage * 10).round(),
                          child: Container(
                            height: 24,
                            color: z.color,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Zone cards
                  ..._zones.map((z) => _zoneCard(z)),

                  const SizedBox(height: 20),

                  // Source note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Zone classification uses Birdscale NDVI raster. '
                            'Confidence reflects raster resolution and cloud cover.',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _zoneCard(_ZoneData zone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: zone.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(zone.label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${zone.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                    color: zone.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const Text('of parcel',
                  style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoneData {
  final String label;
  final double percentage;
  final Color color;
  _ZoneData(this.label, this.percentage, this.color);
}
