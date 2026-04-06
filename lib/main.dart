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

      // ✅ THEME FIX (your error was here)
      theme: AppTheme.lightTheme,

      // ✅ START SCREEN
      initialRoute: '/',

      // ✅ ROUTES (navigation)
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
