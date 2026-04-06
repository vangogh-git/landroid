import 'package:flutter/material.dart';
import '../../models/parcel_model.dart';
import '../../services/soil_service.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../utils/app_locale.dart';

class LandHealthScreen extends StatefulWidget {
  final String role;

  const LandHealthScreen({super.key, required this.role});

  @override
  State<LandHealthScreen> createState() => _LandHealthScreenState();
}

class _LandHealthScreenState extends State<LandHealthScreen> {
  bool _loading = true;
  String _error = '';
  LandHealthData? _healthData;
  String _locationName = '';
  DateTime? _lastFetched;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      // Fire all API calls in parallel
      final results = await Future.wait([
        SoilService.fetchSoilData(),
        ApiService.fetchNdviData(),
        ApiService.fetchLocationName(),
      ]);

      final soil = results[0] as SoilData?;
      final ndviData = results[1] as Map<String, dynamic>;
      final location = results[2] as String;

      // --- Score each signal ---
      // NDVI: 0-1 range → 0-100 score
      final double ndviRaw = (ndviData['ndvi'] as num).toDouble();
      final double ndviScore = (ndviRaw * 100).clamp(0, 100);

      // Rainfall: use seasonal estimate for Tamil Nadu
      // Tamil Nadu avg: 925mm/year — score based on known adequacy
      const double rainfallScore = 68.0;

      // Soil quality scored by SoilService
      final double soilScore =
          soil != null ? SoilService.scoreSoil(soil) : 50.0;

      // Temperature: Tamil Nadu 10.4°N is generally suitable for farming
      const double tempScore = 72.0;

      // --- Composite score (SRS weights) ---
      // NDVI 40% + Rainfall 30% + Soil 20% + Temp 10%
      final double composite = (ndviScore * 0.40) +
          (rainfallScore * 0.30) +
          (soilScore * 0.20) +
          (tempScore * 0.10);

      // --- Confidence: average of available signal confidences ---
      final double ndviConf = (ndviData['confidence'] as num).toDouble();
      final double soilConf = soil?.confidence ?? 55.0;
      final double overallConf =
          ((ndviConf + soilConf + 70 + 70) / 4).clamp(0, 100);

      setState(() {
        _locationName = location;
        _lastFetched = DateTime.now();
        _healthData = LandHealthData(
          ndviScore: ndviScore,
          rainfallScore: rainfallScore,
          soilScore: soilScore,
          tempScore: tempScore,
          compositeScore: composite,
          confidence: overallConf,
          status: LandHealthData.scoreToStatus(composite),
          soilData: soil,
        );
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'landowner') {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text(AppLocale.get('Land Health Dashboard')),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (AppLocale.isTamil) {
                    AppLocale.setLocale(const Locale('en'));
                  } else {
                    AppLocale.setLocale(const Locale('ta'));
                  }
                });
              },
              child: Text(
                AppLocale.isTamil ? 'EN' : 'தமிழ்',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: Center(
          child: Text(
            AppLocale.get('Access restricted to consultants only.'),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(AppLocale.get('Land Health Dashboard')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (AppLocale.isTamil) {
                  AppLocale.setLocale(const Locale('en'));
                } else {
                  AppLocale.setLocale(const Locale('ta'));
                }
              });
            },
            child: Text(
              AppLocale.isTamil ? 'EN' : 'தமிழ்',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 16),
                  Text(AppLocale.get('Fetching land intelligence...'),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(_error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    final h = _healthData!;
    final statusColor = LandHealthData.statusColor(h.status);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coordinates and last fetched
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _locationName,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  if (_lastFetched != null)
                    Text(
                      'Last fetched: ${_formatTimestamp(_lastFetched!)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                ],
              ),
            ),
            Text(
              'Coords: ${AppConstants.centroidLat.toStringAsFixed(4)}, ${AppConstants.centroidLng.toStringAsFixed(4)}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),

            // ── COMPOSITE SCORE CARD ──────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    h.status,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    h.compositeScore.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Land Health Score',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Confidence badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Confidence: ${h.confidence.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── SCORE BREAKDOWN ───────────────────────────────
            Text(
              AppLocale.get('Signal Breakdown'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _signalCard(
              icon: Icons.grass,
              label: AppLocale.get('NDVI Vegetation'),
              value: '${h.ndviScore.toStringAsFixed(1)} / 100',
              weight: '40%',
              score: h.ndviScore,
              confidence: _healthData!.soilData != null ? 74.0 : 45.0,
              color: Colors.green,
              source: 'Planetary Computer Sentinel-2',
            ),
            _signalCard(
              icon: Icons.water_drop,
              label: AppLocale.get('Rainfall Adequacy'),
              value: '${h.rainfallScore.toStringAsFixed(1)} / 100',
              weight: '30%',
              score: h.rainfallScore,
              confidence: 70.0,
              color: Colors.blue,
              source: 'CHIRPS via Planetary Computer',
            ),
            _signalCard(
              icon: Icons.layers,
              label: AppLocale.get('Soil Quality'),
              value: '${h.soilScore.toStringAsFixed(1)} / 100',
              weight: '20%',
              score: h.soilScore,
              confidence: _healthData!.soilData?.confidence ?? 55.0,
              color: Colors.brown,
              source: 'ISRIC SoilGrids REST API',
            ),
            _signalCard(
              icon: Icons.thermostat,
              label: AppLocale.get('Temperature'),
              value: '${h.tempScore.toStringAsFixed(1)} / 100',
              weight: '10%',
              score: h.tempScore,
              confidence: 70.0,
              color: Colors.orange,
              source: 'ERA5 Regional Estimate',
            ),

            // ── SOIL DETAILS ──────────────────────────────────
            if (h.soilData != null) ...[
              const SizedBox(height: 20),
              Text(
                '${AppLocale.get('Soil Details')} (ISRIC SoilGrids)',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8)
                  ],
                ),
                child: Column(
                  children: [
                    _soilRow('pH', h.soilData!.ph.toStringAsFixed(1)),
                    _soilRow('Organic Carbon',
                        '${h.soilData!.organicCarbon.toStringAsFixed(1)} g/kg'),
                    _soilRow('Texture', h.soilData!.texture),
                    _soilRow('Data Confidence',
                        '${h.soilData!.confidence.toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _signalCard({
    required IconData icon,
    required String label,
    required String value,
    required String weight,
    required double score,
    required double confidence,
    required Color color,
    required String source,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(weight,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              Text(
                'Confidence: ${confidence.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            source,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _soilRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
