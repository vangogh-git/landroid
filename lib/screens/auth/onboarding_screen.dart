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