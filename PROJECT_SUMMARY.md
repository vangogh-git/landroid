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
16. [API Integrations](#api-integrations)
17. [Localization](#localization)
18. [Commit History](#commit-history)

---

## Project Overview

**Project Name:** Landroid  
**Type:** Smart Farming Flutter App  
**SDK Version:** >=3.0.0 <4.0.0  
**Platform Targets:** Android, iOS, Web, Windows, Linux, macOS

This is a dual-purpose application for:
- **Land Owners (Farmers):** View parcel health, soil status, AI recommendations, alerts
- **Land Consultants:** Manage parcels, review land health, valuation, coordinate with owners

**Key Features:**
- Interactive GIS parcel map with polygon boundaries
- AI-powered land health analysis (NDVI, Soil, Rainfall, Temperature)
- Plant zone classification (NDVI-based)
- Land valuation estimation
- Bilingual support (English + Tamil)
- Role-based access control (Landowner vs Consultant)

---

## Project Structure

```
lib/
├── main.dart                          # Entry point (55 lines)
├── config/
│   ├── app_routes.dart               # Route definitions (16 lines)
│   └── app_theme.dart                # Theme configuration (21 lines)
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # Login screen (20 lines)
│   │   ├── onboarding_screen.dart    # Role selection (50 lines)
│   │   └── auth_landing_screen.dart  # Landing with role buttons (149 lines)
│   ├── dashboard/
│   │   │   ├── consultant_dashboard.dart # Consultant panel (299 lines)
│   │   │   └── landowner_dashboard.dart  # Landowner dashboard (298 lines)
│   ├── map/
│   │   │   └── parcel_map_screen.dart    # Interactive map with polygon (226 lines)
│   ├── ai/
│   │   │   ├── plant_zone_screen.dart    # NDVI zone classification (232 lines)
│   │   │   ├── land_health_screen.dart   # Land health dashboard (470 lines)
│   │   │   └── land_valuation_screen.dart # Land valuation (382 lines)
│   └── parcel/
│   │       ├── create_parcel_screen.dart  # Empty stub (0 lines)
│   │       └── parcel_details_screen.dart # Empty stub (0 lines)
├── services/
│   │   ├── auth_service.dart              # Empty stub (0 lines)
│   │   ├── api_service.dart               # STAC/NDVI/Nominatim API (93 lines)
│   │   ├── soil_service.dart              # SoilGrids API integration (99 lines)
│   │   └── geojson_service.dart           # GeoJSON boundary loader (40 lines)
├── widgets/
│   │   ├── stat_card.dart                 # Statistics display widget (39 lines)
│   │   ├── role_card.dart                 # Role selection card (42 lines)
│   │   ├── map_toggle_button.dart         # Empty stub (0 lines)
│   │   └── primary_button.dart            # Empty stub (0 lines)
├── models/
│   │   ├── user_model.dart                # Empty stub (0 lines)
│   │   └── parcel_model.dart              # SoilData, LandHealthData, NdviZone (70 lines)
├── data/
│   │   └── dummy_data.dart                # Empty stub (0 lines)
└── utils/
    │   ├── app_locale.dart               # i18n English/Tamil (98 lines)
    │   ├── color_utils.dart              # Empty stub (0 lines)
    │   ├── helpers.dart                  # Empty stub (0 lines)
    │   └── constants.dart                # API endpoints, coords (18 lines)
```

---

## pubspec.yaml Configuration

**File:** `pubspec.yaml` (26 lines)

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
  http: ^1.2.1               # HTTP client for API calls

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
- `http: ^1.2.1` - HTTP client for REST API calls

---

## Main Entry Point

**File:** `lib/main.dart` (55 lines)

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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case '/landowner':
            return MaterialPageRoute(
                builder: (_) => const LandownerDashboard(role: 'landowner'));
          case '/consultant':
            return MaterialPageRoute(
                builder: (_) => const ConsultantDashboard(role: 'consultant'));
          case '/map':
            return MaterialPageRoute(
                builder: (_) => const ParcelMapScreen(role: 'consultant'));
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}
```

**Key Points:**
- Uses `MaterialApp` with `onGenerateRoute` for navigation
- Initial route: `/` (LoginScreen)
- Theme: `AppTheme.lightTheme`
- Role parameter passed to dashboards (`role: 'landowner'` or `role: 'consultant'`)

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
    "/consultant": (context) => const ConsultantDashboard(role: 'consultant'),
    "/landowner": (context) => const LandownerDashboard(role: 'landowner'),
    "/map": (context) => const ParcelMapScreen(role: 'consultant'),
  };
}
```

**Note:** Routes are defined in main.dart directly via `onGenerateRoute`, not using AppRoutes.

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
**File:** `lib/screens/auth/onboarding_screen.dart` (50 lines)

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

Features:
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
**File:** `lib/screens/dashboard/landowner_dashboard.dart` (298 lines)

**Features:**
- Parcel Summary Banner with location & area
- Health Score stat card (58/100)
- Parcel Area stat (~2.3 acres)
- AI Modules menu tiles:
  - GIS Parcel Map (teal)
  - Land Health Dashboard (green)
  - Plant Health Zones (light green)
- Language toggle (EN/தமிழ்)
- Role-aware navigation

**Key Methods:**
- `_parcelSummaryBanner()` - Shows parcel status badge
- `_statCard()` - Stat display with icon, value, subtitle
- `_menuTile()` - Navigation tile for AI modules

---

#### 5. Consultant Dashboard
**File:** `lib/screens/dashboard/consultant_dashboard.dart` (299 lines)

**Features:**
- Parcel Summary Banner with location & area
- Parcels Managed stat (1)
- Alerts stat (0 Active)
- Tools menu tiles:
  - GIS Parcel Map (teal)
  - Land Health Dashboard (green)
  - Plant Health Zones (light green)
  - Land Valuation (amber) - **Consultant only**
- Language toggle (EN/தமிழ்)

---

### Map Screen

#### 6. Parcel Map Screen
**File:** `lib/screens/map/parcel_map_screen.dart` (226 lines)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../services/geojson_service.dart';

class ParcelMapScreen extends StatefulWidget {
  final String role;

  const ParcelMapScreen({super.key, required this.role});

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

  // ... center calculation, polygon rendering, layer toggle
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

### AI Screens

#### 7. Plant Zone Screen
**File:** `lib/screens/ai/plant_zone_screen.dart` (232 lines)

**Features:**
- NDVI Zone Classification with confidence %
- Visual zone distribution bar
- Four zone categories:
  - Dense (NDVI > 0.6) - Dark Green (28.4%)
  - Healthy (0.4 – 0.6) - Green (35.2%)
  - Sparse (0.2 – 0.4) - Yellow (24.1%)
  - Bare / Stressed (< 0.2) - Red (12.3%)
- Refresh button to recompute
- Access restricted for landowners (read-only consultant feature)

---

#### 8. Land Health Screen
**File:** `lib/screens/ai/land_health_screen.dart` (470 lines)

**Features:**
- Composite Land Health Score (0-100)
- Signal Breakdown with weighted scores:
  - NDVI Vegetation (40% weight)
  - Rainfall Adequacy (30% weight)
  - Soil Quality (20% weight)
  - Temperature (10% weight)
- Data sources displayed:
  - Planetary Computer Sentinel-2 (NDVI)
  - CHIRPS via Planetary Computer (Rainfall)
  - ISRIC SoilGrids REST API (Soil)
  - ERA5 Regional Estimate (Temperature)
- Soil Details card (pH, Organic Carbon, Texture, Confidence)
- Language toggle (English/Tamil)
- Refresh functionality
- Last fetched timestamp
- Coordinates display

---

#### 9. Land Valuation Screen
**File:** `lib/screens/ai/land_valuation_screen.dart` (382 lines)

**Features:**
- Estimated Value Range per acre (Low/Mid/High in INR)
- Composite Score (0-100)
- Confidence percentage
- Top Factors analysis:
  - Health Score (30% weight)
  - Soil Quality (20% weight)
  - Rainfall (15% weight)
  - OSM Proximity (25% weight)
  - Night Light (10% weight)
- Positive/Negative impact indicators
- Base price: ₹500,000/acre
- Disclaimer: "Estimated intelligence range, not a legal valuation"
- Access restricted for landowners (consultant only)

---

### Empty Screens (Stubs)

| File | Status |
|------|--------|
| `lib/screens/parcel/create_parcel_screen.dart` | Empty (0 lines) |
| `lib/screens/parcel/parcel_details_screen.dart` | Empty (0 lines) |

---

## Services

### 1. GeoJSON Service
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
    // Handles both LineString and Polygon formats
    // Returns List<LatLng> coordinates
  }
}
```

**Functionality:**
- Loads GeoJSON from `assets/boundary_wgs84.geojson`
- Parses FeatureCollection → Feature → Geometry → Coordinates
- Handles both LineString and Polygon formats
- Returns List<LatLng> coordinates

---

### 2. API Service
**File:** `lib/services/api_service.dart` (93 lines)

```dart
class ApiService {
  /// Fetch latest Sentinel-2 NDVI value for the parcel bounding box
  static Future<Map<String, dynamic>> fetchNdviData() async {
    // Uses Planetary Computer STAC API
    // Returns: {ndvi, sceneCount, confidence, status}
  }

  /// Fetch location name from OSM Nominatim
  static Future<String> fetchLocationName() async {
    // Uses Nominatim reverse geocoding
    // Returns: "Village, County, State"
  }
}
```

**APIs Used:**
- **Planetary Computer STAC** (`https://planetarycomputer.microsoft.com/api/stac/v1`)
  - Searches Sentinel-2 L2A imagery
  - Filters: bbox, datetime (2024), cloud cover < 20%
  - Returns scene count as proxy for NDVI quality
- **OSM Nominatim** (`https://nominatim.openstreetmap.org/reverse`)
  - Reverse geocoding from lat/lng
  - Returns village, county, state

---

### 3. Soil Service
**File:** `lib/services/soil_service.dart` (99 lines)

```dart
class SoilService {
  static Future<SoilData?> fetchSoilData() async {
    // Uses ISRIC SoilGrids v2.0 API
    // Fetches: pH, Organic Carbon (SOC), Texture Class
    // Depth: 0-5cm
  }

  static double scoreSoil(SoilData soil) {
    // Scores soil 0-100
    // pH optimal 6.0-7.0: +25 points
    // Organic Carbon > 10 g/kg: +15 points
  }
}
```

**API Used:**
- **ISRIC SoilGrids** (`https://rest.isric.org/soilgrids/v2.0/properties/query`)
  - Properties: phh2o (pH), soc (Organic Carbon), texture_class
  - Depth: 0-5cm mean values
  - Returns confidence ~82%

---

### Empty Services (Stubs)

| File | Status |
|------|--------|
| `lib/services/auth_service.dart` | Empty (0 lines) |

---

## Widgets

### 1. Stat Card Widget
**File:** `lib/widgets/stat_card.dart` (39 lines)

```dart
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

  // Renders colored container with title/value
}
```

---

### 2. Role Card Widget
**File:** `lib/widgets/role_card.dart` (42 lines)

```dart
class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  // Renders colored card with icon and title
  // GestureDetector for tap handling
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

### 1. Parcel Model
**File:** `lib/models/parcel_model.dart` (70 lines)

```dart
class SoilData {
  final double ph;
  final double organicCarbon;
  final String texture;
  final double confidence;
}

class LandHealthData {
  final double ndviScore;
  final double rainfallScore;
  final double soilScore;
  final double tempScore;
  final double compositeScore;
  final double confidence;
  final String status;
  final SoilData? soilData;

  static String scoreToStatus(double score);
  static Color statusColor(String status);
}

class NdviZone {
  final String label;
  final double minVal;
  final double maxVal;
  final Color color;
  double percentage;
}
```

---

### Empty Models

| File | Status |
|------|--------|
| `lib/models/user_model.dart` | Empty (0 lines) |

---

## Utils

### 1. Constants
**File:** `lib/utils/constants.dart` (18 lines)

```dart
class AppConstants {
  // Parcel centroid from boundary_wgs84.geojson
  static const double centroidLat = 10.428859;
  static const double centroidLng = 77.304527;

  // Bounding box
  static const double bboxMinLon = 77.303500;
  static const double bboxMinLat = 10.427800;
  static const double bboxMaxLon = 77.305500;
  static const double bboxMaxLat = 10.430000;

  // API endpoints
  static const String soilGridsApi = 'https://rest.isric.org/soilgrids/v2.0/properties/query';
  static const String osmNominatim = 'https://nominatim.openstreetmap.org/reverse';
  static const String planetaryStac = 'https://planetarycomputer.microsoft.com/api/stac/v1';
}
```

---

### 2. App Locale (i18n)
**File:** `lib/utils/app_locale.dart` (98 lines)

```dart
class AppLocale {
  static Locale _locale = const Locale('en');
  
  static bool get isTamil => _locale.languageCode == 'ta';
  
  static String get(String key) {
    return _translations[key]?[_locale.languageCode] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'My Parcel': {'en': 'My Parcel', 'ta': 'என் ஏக்கர்'},
    'Consultant Panel': {'en': 'Consultant Panel', 'ta': 'ஆலோசனை பலகை'},
    'Parcels Managed': {'en': 'Parcels Managed', 'ta': 'நிர்வகிக்கப்படும் ஏக்கர்கள்'},
    'Alerts': {'en': 'Alerts', 'ta': 'விழிப்பூட்டல்கள்'},
    // ... 40+ translations
  };
}
```

**Supported Languages:**
- English (en)
- Tamil (ta)

---

### Empty Utils

| File | Status |
|------|--------|
| `lib/utils/color_utils.dart` | Empty (0 lines) |
| `lib/utils/helpers.dart` | Empty (0 lines) |
| `lib/data/dummy_data.dart` | Empty (0 lines) |

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
      "properties": { "ELEVATION": 0 },
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [77.30452683760231, 10.428859498008162, 0.0],
          // ... 55 more coordinate pairs
        ]
      }
    }
  ]
}
```

**Coordinates:** EPSG:4326 (WGS84)
- Location: Approximately 77.304°E, 10.429°N (Tamil Nadu, India)
- First/last point matches (closed polygon)
- Total coordinate points: 56
- Estimated area: ~2.3 acres

---

## Navigation Flow

```
                    ┌─────────────┐
                    │     /       │
                    │LoginScreen  │
                    └──────┬──────┘
                           │ "Login" button
                           ▼
                    ┌─────────────┐
                    │ /onboarding │
                    │ Onboarding  │
                    └──────┬──────┘
                           │ Role selection
              ┌────────────┴────────────┐
              ▼                         ▼
       ┌────────────┐          ┌────────────┐
       │/consultant │          │/landowner  │
       │Consultant  │          │Landowner   │
       │Dashboard   │          │Dashboard   │
       └─────┬──────┘          └─────┬──────┘
             │                        │
    ┌────────┴────────┐      ┌────────┴────────┐
    ▼                ▼      ▼                ▼
┌─────────┐    ┌─────────┐  ┌─────────┐    ┌─────────┐
│  /map   │    │  /map   │  │  /map  │    │  /map   │
│ Parcel  │    │ Parcel  │  │ Parcel │    │ Parcel  │
│ Map     │    │ Map     │  │ Map    │    │ Map     │
└─────────┘    └─────────┘  └─────────┘    └─────────┘
```

**Consultant Only Routes:**
- Land Valuation Screen
- Full Plant Zone Screen (not restricted view)

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
- Role parameter passed via constructor

### Navigation
- `onGenerateRoute` switch statement in main.dart
- `Navigator.push()` for forward navigation
- `Navigator.pushReplacementNamed()` for role-based navigation
- No deep linking configured

### Styling
- Material Design 3 not explicitly used
- Primary color: Green (#4CAFBA standard green)
- Background: Light gray (#F5F7FA)
- Card-based UI with rounded corners (12-24px radius)
- Box shadows for elevation effect

---

## API Integrations

| API | Endpoint | Purpose | Data |
|-----|----------|---------|------|
| **ISRIC SoilGrids** | `rest.isric.org/soilgrids/v2.0/properties/query` | Soil pH, Organic Carbon, Texture | pH (0-14), SOC (g/kg), Texture Class |
| **Planetary Computer STAC** | `planetarycomputer.microsoft.com/api/stac/v1/search` | Sentinel-2 imagery search | NDVI proxy, scene count, cloud cover |
| **OSM Nominatim** | `nominatim.openstreetmap.org/reverse` | Reverse geocoding | Village, County, State |
| **ArcGIS World Imagery** | `server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}` | Satellite tile layer | Bing Maps aerial imagery |
| **OpenStreetMap** | `tile.openstreetmap.org/{z}/{x}/{y}.png` | Standard tile layer | OSM map tiles |

### Data Flow
```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  SoilService │────▶│  SoilGrids   │────▶│   SoilData   │
│              │     │     API      │     │  (pH, SOC)   │
└──────────────┘     └──────────────┘     └──────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  ApiService   │────▶│  Planetary   │────▶│    NDVI      │
│               │     │   Computer   │     │   (0.2-0.8)  │
└──────────────┘     │     STAC      │     └──────────────┘
                     └──────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  ApiService   │────▶│   Nominatim │────▶│  Location    │
│               │     │     API     │     │    Name      │
└──────────────┘     └──────────────┘     └──────────────┘

        │
        ▼ (Composite Calculation)

┌──────────────┐
│  LandHealth  │ = NDVI(40%) + Rainfall(30%) + Soil(20%) + Temp(10%)
│    Score     │
└──────────────┘

┌──────────────┐
│LandValuation │ = BasePrice * (Composite/100) * band
│    Price     │ = ₹500,000/acre * score * (0.75-1.25)
└──────────────┘
```

---

## Localization

### Supported Languages
- **English (en)** - Default
- **Tamil (ta)** - Full translation support

### Usage
```dart
// In any screen
Text(AppLocale.get('My Parcel')) // Returns: "என் ஏக்கர்" if Tamil

// Toggle language
AppLocale.setLocale(const Locale('ta')) // Set Tamil
AppLocale.setLocale(const Locale('en')) // Set English

// Check current language
AppLocale.isTamil // Returns true/false
```

### Translated Strings (40+ keys)
- My Parcel / Consultant Panel / Parcels Managed / Alerts
- Health Score / Parcel Area / Tools / AI Modules
- GIS Parcel Map / Land Health Dashboard / Plant Health Zones / Land Valuation
- Soil Details / pH / Organic Carbon / Texture
- Access restricted to consultants only

---

## Commit History

| Commit | Message | Files Changed |
|--------|---------|---------------|
| `0eb806c` | horizons | ? |
| `66ae248` | first stable | ? |
| `36363b9` | Revert "fourth" | ? |
| `ee90df6` | fourth | ? |
| `cf3c431` | third | ? |
| `c84021b` | second | assets/boundary_wgs84.geojson, lib/config/app_config.dart, lib/screens/map_screen.dart, pubspec.yaml, reproject_boundary.py |
| `d29d2ec` | first | Initial project setup |

### Changes from Initial Commit (d29d2ec → HEAD)
- **+1226 lines** - PROJECT_SUMMARY.md added
- **+257 lines** - assets/boundary_wgs84.geojson
- **+299 lines** - lib/screens/dashboard/consultant_dashboard.dart
- **+298 lines** - lib/screens/dashboard/landowner_dashboard.dart
- **+470 lines** - lib/screens/ai/land_health_screen.dart
- **+382 lines** - lib/screens/ai/land_valuation_screen.dart
- **+232 lines** - lib/screens/ai/plant_zone_screen.dart
- **+226 lines** - lib/screens/map/parcel_map_screen.dart
- **+149 lines** - lib/screens/auth/auth_landing_screen.dart
- **+99 lines** - lib/services/soil_service.dart
- **+93 lines** - lib/services/api_service.dart
- **+98 lines** - lib/utils/app_locale.dart
- **+70 lines** - lib/models/parcel_model.dart
- **+40 lines** - lib/services/geojson_service.dart
- **+18 lines** - lib/utils/constants.dart
- **-274 lines** - lib/screens/map_screen.dart (reorganized)
- **Total: +4349 lines, -468 lines**

---

## Empty/Stub Files Requiring Implementation

The following files need to be implemented for a complete application:

| File | Expected Purpose |
|------|------------------|
| `lib/screens/parcel/create_parcel_screen.dart` | Create new parcel form |
| `lib/screens/parcel/parcel_details_screen.dart` | View parcel details |
| `lib/services/auth_service.dart` | Authentication logic (OTP, Email) |
| `lib/widgets/map_toggle_button.dart` | Map layer toggle widget |
| `lib/widgets/primary_button.dart` | Reusable primary button |
| `lib/models/user_model.dart` | User data model |
| `lib/data/dummy_data.dart` | Sample data for testing |
| `lib/utils/color_utils.dart` | Color utility functions |
| `lib/utils/helpers.dart` | Helper functions |

---

## Summary for AI Code Modification

### If You Need To:
1. **Add new screen:** Create in `lib/screens/[category]/` and add route to `main.dart`
2. **Modify navigation:** Edit routes in `main.dart` (lines 34-52)
3. **Change theme:** Edit `lib/config/app_theme.dart`
4. **Add new map layer:** Modify `ParcelMapScreen`
5. **Update boundary:** Edit `assets/boundary_wgs84.geojson`
6. **Add new widget:** Create in `lib/widgets/` and import where needed
7. **Add translations:** Edit `lib/utils/app_locale.dart` translations map

### Important Line Numbers:
- Main entry: `lib/main.dart:13-15`
- Routes definition: `lib/main.dart:34-52`
- Theme: `lib/config/app_theme.dart:4-19`
- Map center calculation: `lib/screens/map/parcel_map_screen.dart`
- GeoJSON loading: `lib/services/geojson_service.dart:6-17`
- API endpoints: `lib/utils/constants.dart:11-17`
- Boundary coordinates: `assets/boundary_wgs84.geojson`

---

*Generated: April 2026*
*Project: Landroid - Smart Farming App*
