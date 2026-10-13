import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';


class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF171A16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BATTALION CHAI',
            style: TextStyle(
              color: Color(0xFFE68B22),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'देश की जवानी की चाय 🇮🇳',
            style: TextStyle(color: Color(0xFFF2E5C8), fontSize: 16),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _footerLink('Home', AppRoutes.userHomeScreen),
              _footerLink('Menu', AppRoutes.menuScreen),
              _footerLink('About', AppRoutes.aboutScreen),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white24),

          const SizedBox(height: 12),

          const Text(
            '© 2026 Battalion Chai. All rights reserved.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String title, String route) {
    return TextButton(
      onPressed: () => Get.toNamed(route),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
