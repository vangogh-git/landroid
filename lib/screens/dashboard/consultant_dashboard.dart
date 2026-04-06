import 'package:flutter/material.dart';
import '../../utils/app_locale.dart';
import '../map/parcel_map_screen.dart';
import '../ai/land_health_screen.dart';
import '../ai/plant_zone_screen.dart';
import '../ai/land_valuation_screen.dart';

class ConsultantDashboard extends StatefulWidget {
  final String role;

  const ConsultantDashboard({super.key, required this.role});

  @override
  State<ConsultantDashboard> createState() => _ConsultantDashboardState();
}

class _ConsultantDashboardState extends State<ConsultantDashboard> {
  void _toggleLanguage() {
    setState(() {
      if (AppLocale.isTamil) {
        AppLocale.setLocale(const Locale('en'));
      } else {
        AppLocale.setLocale(const Locale('ta'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(AppLocale.get('Consultant Panel')),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _toggleLanguage,
            child: Text(
              AppLocale.isTamil ? 'EN' : 'தமிழ்',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _parcelSummaryBanner(),
            const SizedBox(height: 20),
            _statCard(
              icon: Icons.folder_outlined,
              value: '1',
              subtitle: AppLocale.get('Parcels Managed'),
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _statCard(
              icon: Icons.notifications_outlined,
              value: '0 Active',
              subtitle: AppLocale.get('Alerts'),
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(AppLocale.get('Tools'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _menuTile(
              context,
              icon: Icons.map_outlined,
              label: AppLocale.get('GIS Parcel Map'),
              subtitle: AppLocale.get('Boundary, satellite, layers'),
              color: Colors.teal,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const ParcelMapScreen(role: 'consultant'))),
            ),
            _menuTile(
              context,
              icon: Icons.analytics_outlined,
              label: AppLocale.get('Land Health Dashboard'),
              subtitle:
                  AppLocale.get('Composite score - Soil - NDVI - Rainfall'),
              color: Colors.green,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const LandHealthScreen(role: 'consultant'))),
            ),
            _menuTile(
              context,
              icon: Icons.grass,
              label: AppLocale.get('Plant Health Zones'),
              subtitle: AppLocale.get('NDVI zone classification'),
              color: Colors.lightGreen,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const PlantZoneScreen(role: 'consultant'))),
            ),
            _menuTile(
              context,
              icon: Icons.currency_rupee,
              label: AppLocale.get('Land Valuation'),
              subtitle: AppLocale.get('Value estimate - Price bands - Factors'),
              color: Colors.amber,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const LandValuationScreen(role: 'consultant'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _parcelSummaryBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Parcel Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF57F17)),
                ),
                child: const Text(
                  'Moderate',
                  style: TextStyle(
                    color: Color(0xFFF57F17),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.location_on, '77.30E, 10.43N'),
              const SizedBox(width: 12),
              _infoChip(Icons.square_foot, '~2.3 acres'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.green.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
