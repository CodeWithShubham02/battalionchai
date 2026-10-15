import 'package:battalion_chai/users/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAboutSection extends StatelessWidget {
  const HomeAboutSection({super.key});

  static const Color green = Color(0xFF0D2B1B);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.all(isMobile ? 20 : 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF163C29), green]),
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(220),
                    const SizedBox(height: 24),
                    _buildStory(context, true),
                    const SizedBox(height: 25),
                    _buildHighlights(true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 4, child: _buildImage(220)),
                    const SizedBox(width: 30),
                    Expanded(flex: 5, child: _buildStory(context, false)),
                    const SizedBox(width: 25),
                    Container(
                      width: 1,
                      height: 190,
                      color: cream.withValues(alpha: 0.25),
                    ),
                    const SizedBox(width: 25),
                    Expanded(flex: 3, child: _buildHighlights(false)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildImage(double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=900&auto=format&fit=crop&q=80',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFF244733),
              child: const Icon(Icons.local_cafe, color: cream, size: 65),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStory(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.horizontal_rule, color: saffron, size: 22),
            SizedBox(width: 7),
            Text(
              'ABOUT US',
              style: TextStyle(
                color: cream,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 7),
            Icon(Icons.horizontal_rule, color: saffron, size: 22),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'MORE THAN JUST A CUP',
          style: TextStyle(
            color: cream,
            fontSize: isMobile ? 26 : 27,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Battalion Chai ek sapna hai Shubham Gupta ka, '
          'jo bachpan se apna ek brand banana chahte the. '
          'Chai ke swaad, Indian culture aur apnapan se '
          'inspired, hum is sapne ko ek alag pehchaan dena chahte hain.',
          style: TextStyle(
            color: cream.withValues(alpha: 0.92),
            fontSize: 13,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: () => Get.to(() => const AboutScreen()),
          icon: const Icon(Icons.arrow_forward, size: 17),
          label: const Text('Know More'),
          style: ElevatedButton.styleFrom(
            backgroundColor: saffron,
            foregroundColor: green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlights(bool isMobile) {
    final items = [
      _highlight(Icons.local_cafe, 'OUR DREAM', 'Building a Chai Brand'),
      _highlight(Icons.groups, 'OUR COMMUNITY', 'Made for Togetherness'),
      _highlight(Icons.star, 'OUR PROMISE', 'Taste with Tradition'),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1) const SizedBox(height: 18),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          items[i],
          if (i != items.length - 1) const SizedBox(height: 22),
        ],
      ],
    );
  }

  Widget _highlight(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: cream, size: 35),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: cream,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: cream.withValues(alpha: 0.88),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
