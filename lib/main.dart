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
