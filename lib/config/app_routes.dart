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
