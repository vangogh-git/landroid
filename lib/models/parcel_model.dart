import 'package:flutter/material.dart';
class SoilData {
  final double ph;
  final double organicCarbon;
  final String texture;
  final double confidence;

  SoilData({
    required this.ph,
    required this.organicCarbon,
    required this.texture,
    required this.confidence,
  });
}

class LandHealthData {
  final double ndviScore;       // 0-100
  final double rainfallScore;   // 0-100
  final double soilScore;       // 0-100
  final double tempScore;       // 0-100
  final double compositeScore;  // weighted final score
  final double confidence;      // 0-100
  final String status;          // Healthy / Moderate / At Risk
  final SoilData? soilData;

  LandHealthData({
    required this.ndviScore,
    required this.rainfallScore,
    required this.soilScore,
    required this.tempScore,
    required this.compositeScore,
    required this.confidence,
    required this.status,
    this.soilData,
  });

  static String scoreToStatus(double score) {
    if (score >= 75) return 'Healthy';
    if (score >= 50) return 'Moderate';
    return 'At Risk';
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'Healthy':
        return const Color(0xFF2E7D32);
      case 'Moderate':
        return const Color(0xFFF57F17);
      default:
        return const Color(0xFFC62828);
    }
  }
}

// ignore: avoid_classes_with_only_static_members
class NdviZone {
  final String label;
  final double minVal;
  final double maxVal;
  final Color color;
  double percentage;

  NdviZone({
    required this.label,
    required this.minVal,
    required this.maxVal,
    required this.color,
    this.percentage = 0,
  });
}