import 'package:flutter/material.dart';
import '../../widgets/role_card.dart';
import '../../utils/app_locale.dart';
import '../dashboard/landowner_dashboard.dart';
import '../dashboard/consultant_dashboard.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.get('Select Role'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RoleCard(
              title: AppLocale.get('Land Consultant'),
              icon: Icons.admin_panel_settings,
              color: Colors.green,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ConsultantDashboard(role: 'consultant'),
                  ),
                );
              },
            ),
            RoleCard(
              title: AppLocale.get('Farmer'),
              icon: Icons.person,
              color: Colors.orange,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LandownerDashboard(role: 'landowner'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
