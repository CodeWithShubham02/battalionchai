import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const Color green = Color(0xFF0D2B1B);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: green,
        border: Border(
          top: BorderSide(color: Color(0xFF38523D), width: 1),
          bottom: BorderSide(color: saffron, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          if (isMobile) {
            return Column(
              children: [
                _buildLogo(context),
                const SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: _navigationLinks(),
                ),
                const SizedBox(height: 18),
                _buildSocialLinks(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 3, child: _buildLogo(context)),
              Expanded(
                flex: 5,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: _navigationLinks(),
                ),
              ),
              Expanded(flex: 2, child: _buildSocialLinks()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.userHomeScreen),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Replace with your actual logo asset path.
          Image.asset(
            'assets/images/BattalionChai.png',
            width: 52,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.local_cafe, color: saffron, size: 42);
            },
          ),
          const SizedBox(width: 7),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BATTALION',
                  style: TextStyle(
                    color: cream,
                    fontSize: 15,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  '★ CHAI ★',
                  style: TextStyle(
                    color: saffron,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'देश की जवानी की चाय',
                  style: TextStyle(color: cream, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _navigationLinks() {
    return [
      _footerLink('Home', AppRoutes.userHomeScreen),
      _footerLink('Menu', AppRoutes.menuScreen),
      _footerLink('Branches', null),
      _footerLink('About', AppRoutes.aboutScreen),
      _footerLink('Contact', null),
    ];
  }

  Widget _footerLink(String title, String? route) {
    return TextButton(
      onPressed: () {
        if (route != null) {
          Get.toNamed(route);
        } else {
          Get.snackbar(
            title,
            '$title page route abhi configure nahi hai.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: cream,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(0, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: cream,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Follow Us', style: TextStyle(color: cream, fontSize: 10)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _socialButton(Icons.camera_alt_outlined, 'Instagram'),
            _socialButton(Icons.facebook, 'Facebook'),
            _socialButton(Icons.play_circle_outline, 'YouTube'),
            _socialButton(Icons.close, 'X'),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, String name) {
    return IconButton(
      onPressed: () {
        Get.snackbar(
          'Follow Battalion Chai',
          '$name link configure karna baaki hai.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      icon: Icon(icon, color: cream, size: 21),
      tooltip: name,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
