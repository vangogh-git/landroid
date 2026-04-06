import 'package:flutter/material.dart';
import '../../models/parcel_model.dart';
import '../../services/soil_service.dart';
import '../../services/api_service.dart';

class LandValuationScreen extends StatefulWidget {
  final String role;

  const LandValuationScreen({super.key, required this.role});

  @override
  State<LandValuationScreen> createState() => _LandValuationScreenState();
}

class _LandValuationScreenState extends State<LandValuationScreen> {
  bool _loading = true;
  String _error = '';
  LandValuationData? _valuationData;

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
      final results = await Future.wait([
        SoilService.fetchSoilData(),
        ApiService.fetchNdviData(),
        ApiService.fetchLocationName(),
      ]);

      final soil = results[0] as SoilData?;
      final ndviData = results[1] as Map<String, dynamic>;
      final location = results[2] as String;

      final double ndviRaw = (ndviData['ndvi'] as num).toDouble();
      final double ndviScore = (ndviRaw * 100).clamp(0, 100);

      const double rainfallScore = 68.0;
      final double soilScore =
          soil != null ? SoilService.scoreSoil(soil) : 50.0;

      const double osmProximityScore = 70.0;
      const double nightLightScore = 60.0;

      final double compositeScore = (ndviScore * 0.30) +
          (soilScore * 0.20) +
          (rainfallScore * 0.15) +
          (osmProximityScore * 0.25) +
          (nightLightScore * 0.10);

      const double basePricePerAcre = 500000.0;
      final double midPrice = basePricePerAcre * (compositeScore / 100);
      final double lowPrice = midPrice * 0.75;
      final double highPrice = midPrice * 1.25;

      final double confidence = ((ndviData['confidence'] as num).toDouble() +
              (soil?.confidence ?? 55.0) +
              70 +
              65 +
              60) /
          5;

      final factors = _calculateFactors(
        healthScore: ndviScore,
        soilScore: soilScore,
        rainfallScore: rainfallScore,
        osmProximityScore: osmProximityScore,
        nightLightScore: nightLightScore,
      );

      setState(() {
        _valuationData = LandValuationData(
          location: location,
          lowPrice: lowPrice,
          midPrice: midPrice,
          highPrice: highPrice,
          confidence: confidence.clamp(0, 100),
          compositeScore: compositeScore,
          factors: factors,
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

  List<ValuationFactor> _calculateFactors({
    required double healthScore,
    required double soilScore,
    required double rainfallScore,
    required double osmProximityScore,
    required double nightLightScore,
  }) {
    final allFactors = [
      ValuationFactor(name: 'Health Score', score: healthScore, weight: 0.30),
      ValuationFactor(name: 'Soil Quality', score: soilScore, weight: 0.20),
      ValuationFactor(name: 'Rainfall', score: rainfallScore, weight: 0.15),
      ValuationFactor(
          name: 'OSM Proximity', score: osmProximityScore, weight: 0.25),
      ValuationFactor(
          name: 'Night Light', score: nightLightScore, weight: 0.10),
    ];

    allFactors.sort((a, b) => b.score.compareTo(a.score));

    final topPositive = allFactors
        .where((f) => f.score >= 65)
        .take(2)
        .map((f) => ValuationFactor(
              name: f.name,
              score: f.score,
              weight: f.weight,
              impact: 'positive',
            ))
        .toList();

    final topNegative = allFactors
        .where((f) => f.score < 65)
        .take(1)
        .map((f) => ValuationFactor(
              name: f.name,
              score: f.score,
              weight: f.weight,
              impact: 'negative',
            ))
        .toList();

    return [...topPositive, ...topNegative];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'landowner') {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('Land Valuation'),
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
        title: const Text('Land Valuation'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Colors.amber),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Estimated intelligence range, not a legal valuation',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.amber),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
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
                            Text(
                              _valuationData!.location,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Estimated Value Range',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _priceColumn('Low', _valuationData!.lowPrice,
                                    Colors.red),
                                _priceColumn('Mid', _valuationData!.midPrice,
                                    Colors.orange),
                                _priceColumn('High', _valuationData!.highPrice,
                                    Colors.green),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Composite Score',
                                    style: TextStyle(fontSize: 14)),
                                Text(
                                    '${_valuationData!.compositeScore.toStringAsFixed(1)} / 100',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Confidence',
                                    style: TextStyle(fontSize: 14)),
                                Text(
                                    '${_valuationData!.confidence.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Top Factors',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ..._valuationData!.factors.map((f) => _factorCard(f)),
                    ],
                  ),
                ),
    );
  }

  Widget _priceColumn(String label, double price, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('₹${_formatPrice(price)}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const Text('/acre', style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(1)}Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(1)}L';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }

  Widget _factorCard(ValuationFactor factor) {
    final isPositive = factor.impact == 'positive';
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(factor.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                    '${(factor.weight * 100).toStringAsFixed(0)}% weight • Score: ${factor.score.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LandValuationData {
  final String location;
  final double lowPrice;
  final double midPrice;
  final double highPrice;
  final double confidence;
  final double compositeScore;
  final List<ValuationFactor> factors;

  LandValuationData({
    required this.location,
    required this.lowPrice,
    required this.midPrice,
    required this.highPrice,
    required this.confidence,
    required this.compositeScore,
    required this.factors,
  });
}

class ValuationFactor {
  final String name;
  final double score;
  final double weight;
  final String impact;

  ValuationFactor({
    required this.name,
    required this.score,
    required this.weight,
    this.impact = 'neutral',
  });
}
