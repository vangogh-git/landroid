# Landroid Flutter Project - Complete Codebase Summary

## Table of Contents
1. [Project Overview](#project-overview)
2. [Project Structure](#project-structure)
3. [pubspec.yaml Configuration](#pubspecyaml-configuration)
4. [Main Entry Point](#main-entry-point)
5. [Routes Configuration](#routes-configuration)
6. [Theme Configuration](#theme-configuration)
7. [Screens (Views)](#screens-views)
8. [Services](#services)
9. [Widgets](#widgets)
10. [Models](#models)
11. [Data](#data)
12. [Utils](#utils)
13. [Assets](#assets)
14. [Navigation Flow](#navigation-flow)
15. [Key Implementation Details](#key-implementation-details)
16. [Empty/Stub Files](#emptystub-files)

---

## Project Overview

**Project Name:** Landroid  
**Type:** Smart Farming Flutter App  
**SDK Version:** >=3.0.0 <4.0.0  
**Platform Targets:** Android, iOS, Web, Windows, Linux, macOS

This is a dual-purpose application for:
- **Land Owners (Farmers):** View parcel health, soil status, and alerts
- **Land Consultants:** Manage parcels, review land, coordinate with owners

---

## Project Structure

```
lib/
├── main.dart                          # Entry point (43 lines)
├── config/
│   ├── app_routes.dart               # Route definitions (16 lines)
│   └── app_theme.dart                # Theme configuration (21 lines)
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # Login screen (20 lines)
│   │   ├── onboarding_screen.dart    # Role selection (36 lines)
│   │   └── auth_landing_screen.dart  # Landing with role buttons (149 lines)
│   ├── dashboard/
│   │   ├── consultant_dashboard.dart # Consultant stats (57 lines)
│   │   └── landowner_dashboard.dart   # Landowner stats (57 lines)
│   ├── map/
│   │   └── parcel_map_screen.dart    # Interactive map with polygon (224 lines)
│   ├── ai/
│   │   ├── plant_zone_screen.dart    # Empty stub
│   │   └── land_health_screen.dart    # Empty stub
│   └── parcel/
│       ├── create_parcel_screen.dart  # Empty stub
│       └── parcel_details_screen.dart # Empty stub
├── services/
│   ├── auth_service.dart              # Empty stub
│   ├── api_service.dart               # Empty stub
│   ├── soil_service.dart              # Empty stub
│   └── geojson_service.dart           # GeoJSON boundary loader (40 lines)
├── widgets/
│   ├── stat_card.dart                 # Statistics display widget (39 lines)
│   ├── role_card.dart                 # Role selection card (42 lines)
│   ├── map_toggle_button.dart         # Empty stub
│   └── primary_button.dart            # Empty stub
├── models/
│   ├── user_model.dart                # Empty stub
│   └── parcel_model.dart              # Empty stub
├── data/
│   └── dummy_data.dart                # Empty stub
└── utils/
    ├── color_utils.dart               # Empty stub
    ├── helpers.dart                   # Empty stub
    └── constants.dart                 # Empty stub
```

---

## pubspec.yaml Configuration

**File:** `pubspec.yaml` (25 lines)

```yaml
name: landroid
description: Smart Farming App
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^7.0.2        # Map rendering
  latlong2: ^0.9.0           # Lat/Lng coordinate handling

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/boundary_wgs84.geojson
```

**Dependencies Used:**
- `flutter_map: ^7.0.2` - OpenStreetMap/ArcGIS map rendering
- `latlong2: ^0.9.0` - Geographic coordinate handling

---

## Main Entry Point

**File:** `lib/main.dart` (43 lines)

```dart
import 'package:flutter/material.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/dashboard/landowner_dashboard.dart';
import 'screens/dashboard/consultant_dashboard.dart';
import 'screens/map/parcel_map_screen.dart';

// Theme
import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Landroid',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/landowner': (context) => const LandownerDashboard(),
        '/consultant': (context) => const ConsultantDashboard(),
        '/map': (context) => const ParcelMapScreen(),
      },
    );
  }
}
```

**Key Points:**
- Uses `MaterialApp` with named routes
- Initial route: `/` (LoginScreen)
- Theme: `AppTheme.lightTheme` (defined in config/app_theme.dart)

---

## Routes Configuration

**File:** `lib/config/app_routes.dart` (16 lines)

```dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/dashboard/consultant_dashboard.dart';
import '../screens/dashboard/landowner_dashboard.dart';
import '../screens/map/parcel_map_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    "/": (context) => const LoginScreen(),
    "/onboarding": (context) => const OnboardingScreen(),
    "/consultant": (context) => const ConsultantDashboard(),
    "/landowner": (context) => const LandownerDashboard(),
    "/map": (context) => const ParcelMapScreen(),
  };
}
```

**Note:** This file is defined but NOT used - routes are directly defined in `main.dart`.

---

## Theme Configuration

**File:** `lib/config/app_theme.dart` (21 lines)

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
```

**Theme Settings:**
- Primary color: Green
- Background: #F5F7FA (light gray)
- AppBar: Green background, no elevation
- Buttons: Green background, 12px border radius

---

## Screens (Views)

### Authentication Screens

#### 1. Login Screen
**File:** `lib/screens/auth/login_screen.dart` (20 lines)

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/onboarding");
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
```

**Behavior:**
- Green-tinted background (green.shade50)
- Single "Login" button navigates to `/onboarding`

---

#### 2. Onboarding Screen
**File:** `lib/screens/auth/onboarding_screen.dart` (36 lines)

```dart
import 'package:flutter/material.dart';
import '../../widgets/role_card.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RoleCard(
              title: "Land Consultant",
              icon: Icons.admin_panel_settings,
              color: Colors.green,
              onTap: () {
                Navigator.pushReplacementNamed(context, "/consultant");
              },
            ),
            RoleCard(
              title: "Farmer",
              icon: Icons.person,
              color: Colors.orange,
              onTap: () {
                Navigator.pushReplacementNamed(context, "/landowner");
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Behavior:**
- AppBar with title "Select Role"
- Two RoleCards: "Land Consultant" (green) and "Farmer" (orange)
- Routes: `/consultant` or `/landowner`

---

#### 3. Auth Landing Screen
**File:** `lib/screens/auth/auth_landing_screen.dart` (149 lines)

```dart
import 'package:flutter/material.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo container (lines 38-50)
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.park_rounded,
                        size: 46,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title "Landroid" (lines 52-58)
                    const Text(
                      'Landroid',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle (lines 60-67)
                    Text(
                      'Land intelligence for consultants and farmers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Role buttons (lines 70-90)
                    _roleButton(
                      context: context,
                      title: 'Land Owner',
                      subtitle: 'OTP login',
                      icon: Icons.person_rounded,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/landowner');
                      },
                    ),
                    const SizedBox(height: 14),
                    _roleButton(
                      context: context,
                      title: 'Land Consultant',
                      subtitle: 'Email login',
                      icon: Icons.badge_rounded,
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/consultant');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method (lines 101-148)
  Widget _roleButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
```

**UI Elements:**
- Green gradient background (0xFF1B5E20 to 0xFF66BB6A)
- White card with shadow (maxWidth: 420, borderRadius: 24)
- Park icon logo (84x84, circle, green tint)
- Title: "Landroid" (30px, bold)
- Subtitle: "Land intelligence for consultants and farmers"
- Two role buttons:
  - "Land Owner" (orange) → `/landowner`
  - "Land Consultant" (green) → `/consultant`

---

### Dashboard Screens

#### 4. Landowner Dashboard
**File:** `lib/screens/dashboard/landowner_dashboard.dart` (57 lines)

```dart
import 'package:flutter/material.dart';

class LandownerDashboard extends StatelessWidget {
  const LandownerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Land Owner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/map'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card('Health Score', '78%', Colors.green),
            _card('Soil Status', 'Moderate', Colors.orange),
            _card('Parcel Alerts', '2 active', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Display:**
- AppBar: "Land Owner" with map button → `/map`
- Three stat cards:
  - Health Score: 78% (green)
  - Soil Status: Moderate (orange)
  - Parcel Alerts: 2 active (red)

---

#### 5. Consultant Dashboard
**File:** `lib/screens/dashboard/consultant_dashboard.dart` (57 lines)

```dart
import 'package:flutter/material.dart';

class ConsultantDashboard extends StatelessWidget {
  const ConsultantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/map'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card('Parcels Managed', '12', Colors.green),
            _card('Need Review', '3', Colors.orange),
            _card('Assigned Owners', '9', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Display:**
- AppBar: "Consultant" with map button → `/map`
- Three stat cards:
  - Parcels Managed: 12 (green)
  - Need Review: 3 (orange)
  - Assigned Owners: 9 (blue)

---

### Map Screen

#### 6. Parcel Map Screen
**File:** `lib/screens/map/parcel_map_screen.dart` (224 lines)

```dart
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

          // Floating buttons (lines 135-157)
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

          // Legend (lines 159-200)
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
```

**Key Features:**
- Loads boundary from GeoJSON via `GeoJsonService.loadBoundaryPoints()`
- State: `boundaryPoints` (List<LatLng>), `isSatellite` (bool)
- Map tile providers:
  - Satellite: ArcGIS World Imagery
  - Standard: OpenStreetMap
- Layers:
  - PolygonLayer: Green fill (alpha 0.28), green border
  - PolylineLayer: Green stroke
  - MarkerLayer: Red marker at center point
- Initial zoom: 17
- Floating buttons: layers toggle, my location
- Legend box in bottom-left

---

## Services

### GeoJSON Service
**File:** `lib/services/geojson_service.dart` (40 lines)

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonService {
  static Future<List<LatLng>> loadBoundaryPoints() async {
    final raw = await rootBundle.loadString('assets/boundary_wgs84.geojson');
    final data = jsonDecode(raw);

    final features = data['features'] as List<dynamic>;
    if (features.isEmpty) return [];

    final geometry = features.first['geometry'];
    final coords = geometry['coordinates'];

    return _extractPoints(coords);
  }

  static List<LatLng> _extractPoints(dynamic coordinates) {
    if (coordinates is! List || coordinates.isEmpty) return [];

    final first = coordinates.first;

    // LineString: [ [lng, lat], [lng, lat], ... ]
    if (first is List && first.isNotEmpty && first.first is num) {
      return coordinates.map<LatLng>((p) {
        final lng = (p[0] as num).toDouble();
        final lat = (p[1] as num).toDouble();
        return LatLng(lat, lng);
      }).toList();
    }

    // Polygon: [ [ [lng, lat], ... ] ]
    if (first is List && first.isNotEmpty && first.first is List) {
      return _extractPoints(first);
    }

    return [];
  }
}
```

**Functionality:**
- Loads GeoJSON from `assets/boundary_wgs84.geojson`
- Parses FeatureCollection → Feature → Geometry → Coordinates
- Handles both LineString and Polygon formats
- Returns List<LatLng> coordinates

---

### Empty Services (Stubs)

| File | Status |
|------|--------|
| `lib/services/auth_service.dart` | Empty (0 lines) |
| `lib/services/api_service.dart` | Empty (0 lines) |
| `lib/services/soil_service.dart` | Empty (0 lines) |

---

## Widgets

### 1. Stat Card Widget
**File:** `lib/widgets/stat_card.dart` (39 lines)

```dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```

---

### 2. Role Card Widget
**File:** `lib/widgets/role_card.dart` (42 lines)

```dart
import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
```

---

### Empty Widgets (Stubs)

| File | Status |
|------|--------|
| `lib/widgets/map_toggle_button.dart` | Empty (0 lines) |
| `lib/widgets/primary_button.dart` | Empty (0 lines) |

---

## Models

| File | Status |
|------|--------|
| `lib/models/user_model.dart` | Empty (0 lines) |
| `lib/models/parcel_model.dart` | Empty (0 lines) |

---

## Data

| File | Status |
|------|--------|
| `lib/data/dummy_data.dart` | Empty (0 lines) |

---

## Utils

| File | Status |
|------|--------|
| `lib/utils/color_utils.dart` | Empty (0 lines) |
| `lib/utils/helpers.dart` | Empty (0 lines) |
| `lib/utils/constants.dart` | Empty (0 lines) |

---

## Assets

### Boundary GeoJSON
**File:** `assets/boundary_wgs84.geojson` (257 lines)

```json
{
  "type": "FeatureCollection",
  "crs": {
    "type": "name",
    "properties": {
      "name": "urn:ogc:def:crs:EPSG::4326"
    }
  },
  "features": [
    {
      "type": "Feature",
      "properties": {
        "ELEVATION": 0
      },
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [77.30452683760231, 10.428859498008162, 0.0],
          [77.30452659640771, 10.429019068413671, 0.0],
          // ... 55 more coordinate pairs
          [77.30452683760231, 10.428859498008162, 0.0]
        ]
      }
    }
  ]
}
```

**Coordinates:** EPSG:4326 (WGS84)
- Location: Approximately 77.30°E, 10.43°N (India)
- First/last point matches (closed polygon)
- Total coordinate points: 56

---

## Navigation Flow

```
                    ┌─────────────┐
                    │  /          │
                    │ LoginScreen │
                    └──────┬──────┘
                           │ "Login" button
                           ▼
                    ┌─────────────┐
                    │/onboarding  │
                    │Onboarding   │
                    └──────┬──────┘
                           │ Role selection
              ┌────────────┴────────────┐
              ▼                         ▼
       ┌────────────┐          ┌────────────┐
       │/consultant │          │/landowner  │
       │Consultant  │          │Landowner   │
       │Dashboard   │          │Dashboard   │
       └─────┬──────┘          └─────┬──────┘
             │ Map button              │ Map button
             ▼                         ▼
       ┌─────────────┐          ┌─────────────┐
       │   /map      │          │   /map      │
       │ParcelMap    │          │ParcelMap    │
       │Screen       │          │Screen       │
       └─────────────┘          └─────────────┘
```

---

## Key Implementation Details

### Map Implementation
- **Library:** flutter_map (v7.0.2)
- **Coordinates:** latlong2 package
- **Tile Providers:**
  - ArcGIS Satellite: `https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}`
  - OpenStreetMap: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **Boundary:** Loaded from bundled GeoJSON asset

### State Management
- Simple `setState()` for local state
- No provider/BLoC/Redux - all state is local to each screen

### Navigation
- Named routes with `Navigator.pushNamed()`
- `Navigator.pushReplacementNamed()` for role-based navigation
- No deep linking configured

### Styling
- Material Design 3 not explicitly used
- Primary color: Green (#4CAFBA standard green)
- Background: Light gray (#F5F7FA)
- Card-based UI with rounded corners (16-24px radius)

---

## Empty/Stub Files Requiring Implementation

The following files need to be implemented for a complete application:

| File | Expected Purpose |
|------|------------------|
| `lib/screens/ai/plant_zone_screen.dart` | AI plant zone recommendations |
| `lib/screens/ai/land_health_screen.dart` | AI land health analysis |
| `lib/screens/parcel/create_parcel_screen.dart` | Create new parcel form |
| `lib/screens/parcel/parcel_details_screen.dart` | View parcel details |
| `lib/services/auth_service.dart` | Authentication logic |
| `lib/services/api_service.dart` | API calls to backend |
| `lib/services/soil_service.dart` | Soil data service |
| `lib/widgets/map_toggle_button.dart` | Map layer toggle widget |
| `lib/widgets/primary_button.dart` | Reusable primary button |
| `lib/models/user_model.dart` | User data model |
| `lib/models/parcel_model.dart` | Parcel data model |
| `lib/data/dummy_data.dart` | Sample data for testing |
| `lib/utils/color_utils.dart` | Color utility functions |
| `lib/utils/helpers.dart` | Helper functions |
| `lib/utils/constants.dart` | App constants |

---

## Summary for AI Code Modification

### If You Need To:
1. **Add new screen:** Create in `lib/screens/[category]/` and add route to `main.dart`
2. **Modify navigation:** Edit routes in `main.dart` (lines 34-40)
3. **Change theme:** Edit `lib/config/app_theme.dart`
4. **Add new map layer:** Modify `ParcelMapScreen` (lines 92-132)
5. **Update boundary:** Edit `assets/boundary_wgs84.geojson`
6. **Add new widget:** Create in `lib/widgets/` and import where needed

### Important Line Numbers:
- Main entry: `lib/main.dart:13-15`
- Routes definition: `lib/main.dart:34-40`
- Theme: `lib/config/app_theme.dart:4-19`
- Map center calculation: `lib/screens/map/parcel_map_screen.dart:33-46`
- GeoJSON loading: `lib/services/geojson_service.dart:6-17`
- Boundary coordinates: `assets/boundary_wgs84.geojson:18-253`

---

*Generated: April 2026*
*Project: Landroid - Smart Farming App*
