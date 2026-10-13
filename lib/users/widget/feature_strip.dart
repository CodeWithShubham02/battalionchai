
import 'package:flutter/material.dart';

class FeatureStrip extends StatelessWidget {
  const FeatureStrip({super.key});

  static const Color militaryGreen = Color(0xFF203A2A);
  static const Color cream = Color(0xFFF2E5C8);

  static const List<_FeatureItem> features = [
    _FeatureItem(
      icon: Icons.eco_rounded,
      title: 'Premium',
      subtitle: 'Tea Leaves',
    ),
    _FeatureItem(
      icon: Icons.local_drink_rounded,
      title: 'Pure',
      subtitle: 'Milk',
    ),
    _FeatureItem(
      icon: Icons.spa_rounded,
      title: 'Fresh',
      subtitle: 'Ingredients',
    ),
    _FeatureItem(
      icon: Icons.star_rounded,
      title: 'Authentic',
      subtitle: '',
    ),
    _FeatureItem(
      icon: Icons.local_cafe_rounded,
      title: 'Every Cup',
      subtitle: 'Supports India',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: cream,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(features.length, (index) {
              final feature = features[index];

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFeature(
                        feature,
                        isMobile: isMobile,
                      ),
                    ),

                    if (index != features.length - 1)
                      Container(
                        height: isMobile ? 42 : 60,
                        width: 1,
                        color: militaryGreen.withValues(alpha: 0.16),
                      ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildFeature(
      _FeatureItem feature, {
        required bool isMobile,
      }) {
    final iconSize = isMobile ? 28.0 : 38.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 2 : 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: const BoxDecoration(
              color: militaryGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              feature.icon,
              size: isMobile ? 16 : 22,
              color: cream,
            ),
          ),

          SizedBox(height: isMobile ? 6 : 10),

          Text(
            feature.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: militaryGreen,
              fontSize: isMobile ? 8 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (feature.subtitle.isNotEmpty)
            Text(
              feature.subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: militaryGreen,
                fontSize: isMobile ? 8 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
