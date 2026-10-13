
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routes.dart';


class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  static const Color militaryGreen = Color(0xFF102D1D);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFFF991A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: militaryGreen,
        border: Border(
          bottom: BorderSide(
            color: Color(0x334B704F),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 760;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 30,
                vertical: 10,
              ),
              child: Row(
                children: [
                  // BRAND LOGO
                  _buildLogo(isMobile),

                  const SizedBox(width: 10),

                  // BRAND NAME + TAGLINE
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'BATTALION CHAI',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cream,
                            fontSize: isMobile ? 13 : 19,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'देश की जवानों की चाय',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cream,
                            fontSize: isMobile ? 9 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isMobile) ...[
                    // DESKTOP NAVIGATION
                    _navItem('Home', AppRoutes.userHomeScreen),
                    _navItem('Menu', AppRoutes.menuScreen),
                   _navItem('Branches', AppRoutes.branchScreen),
                    _navItem('About', AppRoutes.aboutScreen),
                    _navItem('Contact', AppRoutes.contactScreen),

                    const SizedBox(width: 12),

                    _orderButton(),

                    const SizedBox(width: 12),
                  ] else ...[
                    // MOBILE ORDER BUTTON
                    _orderButton(isMobile: true),
                  ],

                  // MENU BUTTON
                  PopupMenuButton<String>(
                    tooltip: 'Open menu',
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: cream,
                      size: 25,
                    ),
                    color: militaryGreen,
                    onSelected: (route) {
                      Get.toNamed(route);
                    },
                    itemBuilder: (context) => [
                      _menuItem('Home', AppRoutes.userHomeScreen),
                      _menuItem('Menu', AppRoutes.menuScreen),
                      _menuItem('Branch', AppRoutes.branchScreen),
                      _menuItem('About', AppRoutes.aboutScreen),
                      _menuItem('Contact', AppRoutes.contactScreen),
                      _menuItem('Login', AppRoutes.adminLogin),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(bool isMobile) {
    return Container(
      width: isMobile ? 42 : 54,
      height: isMobile ? 42 : 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: saffron,
          width: 1.5,
        ),
        color: const Color(0xFF203A2A),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/battalion_logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.local_cafe_rounded,
              color: saffron,
              size: 29,
            );
          },
        ),
      ),
    );
  }

  Widget _navItem(String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: TextButton(
        onPressed: () => Get.toNamed(route),
        style: TextButton.styleFrom(
          foregroundColor: cream,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _orderButton({bool isMobile = false}) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(AppRoutes.menuScreen);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: const Color(0xFF171A16),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 11 : 14,
        ),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isMobile ? 'Menu' : 'Order Now',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 7),
          const Icon(
            Icons.local_cafe_rounded,
            size: 17,
          ),
        ],
      ),
    );
  }

  PopupMenuEntry<String> _menuItem(
      String title,
      String route,
      ) {
    return PopupMenuItem<String>(
      value: route,
      child: Text(
        title,
        style: const TextStyle(color: cream),
      ),
    );
  }
}
