import 'package:battalion_chai/users/widget/app_footer_screen.dart';
import 'package:battalion_chai/users/widget/app_header_screen.dart';
import 'package:battalion_chai/users/widget/feature_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_routes.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  static const Color militaryGreen = Color(0xFF203A2A);
  static const Color cardGreen = Color(0xFF163C29);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);
  static const Color textDark = Color(0xFF172D20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: militaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header stays at the top.
            const AppHeader(),

            // Only page content scrolls.
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroBanner(),

                    const FeatureStrip(),

                    // Best Sellers section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 35,
                      ),
                      child: _buildBestSellers(context),
                    ),

                    // Welcome section
                    Container(
                      color: cream,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 35,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'EK CUP DESH KE NAAM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: militaryGreen,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chai ka swaad, jawano ka jazba!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: militaryGreen,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 22),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(AppRoutes.menuScreen);
                            },
                            icon: const Icon(Icons.local_cafe),
                            label: const Text('Explore Our Menu'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: saffron,
                              foregroundColor: militaryGreen,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 17,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const AppFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HERO BANNER
  Widget _buildHeroBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 350;

        return AspectRatio(
          aspectRatio: isMobile ? 1.15 : 2.43,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/BattalionChai.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: militaryGreen,
                    alignment: Alignment.center,
                    child: const Text(
                      'Battalion Chai',
                      style: TextStyle(
                        color: cream,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),

              // Banner button area
              Positioned(
                left: constraints.maxWidth * 0.045,
                bottom: constraints.maxWidth * 0.055,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.menuScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saffron,
                    foregroundColor: militaryGreen,
                  ),
                  child: const Text('Explore Our Menu'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // BEST SELLERS: fetch from Firestore, show maximum 5.
  Widget _buildBestSellers(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 25, height: 2, color: saffron),
            const SizedBox(width: 10),
            const Text(
              'O U R   S P E C I A L',
              style: TextStyle(
                color: cream,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 25, height: 2, color: saffron),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          'BEST SELLERS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cream,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Our most loved drinks & snacks',
          style: TextStyle(color: cream.withValues(alpha: 0.8), fontSize: 13),
        ),
        const SizedBox(height: 25),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo: 'active')
              .where('bestSeller',isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Products load nahi ho paaye.',
                  style: TextStyle(color: cream),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(color: saffron),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            final bestSellers = docs.where((doc) {
              final data = doc.data();
              return data['bestSeller'] == true;
            }).toList();

            // Latest products first.
            bestSellers.sort((a, b) {
              final aTime = a.data()['createdAt'];
              final bTime = b.data()['createdAt'];

              final aDate = aTime is Timestamp
                  ? aTime.toDate()
                  : DateTime(2000);

              final bDate = bTime is Timestamp
                  ? bTime.toDate()
                  : DateTime(2000);

              return bDate.compareTo(aDate);
            });

            // Show maximum 5 products on home.
            final visibleProducts = bestSellers.take(5).toList();

            if (visibleProducts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Abhi koi best seller available nahi hai.',
                  style: TextStyle(color: cream),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isMobile = width < 350;

                if (isMobile) {
                  return SizedBox(
                    height: 245,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: visibleProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 175,
                          child: _buildProductCard(
                            visibleProducts[index].data(),
                          ),
                        );
                      },
                    ),
                  );
                }

                final crossAxisCount = width >= 1100
                    ? 5
                    : width >= 800
                    ? 3
                    : 2;

                final cardWidth =
                    (width - (crossAxisCount - 1) * 14) / crossAxisCount;

                return Wrap(
                  spacing: 14,
                  runSpacing: 18,
                  children: visibleProducts.map((doc) {
                    return SizedBox(
                      width: cardWidth,
                      height: 245,
                      child: _buildProductCard(doc.data()),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),

        const SizedBox(height: 25),

        // MORE BUTTON
        OutlinedButton.icon(
          onPressed: () {
            Get.toNamed(AppRoutes.menuScreen);
          },
          icon: const Icon(Icons.restaurant_menu),
          label: const Text('View More'),
          style: OutlinedButton.styleFrom(
            foregroundColor: cream,
            side: const BorderSide(color: saffron, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // PRODUCT CARD
  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['productName']?.toString() ?? 'Product';
    final description = product['productDescription']?.toString() ?? '';
    final imageUrl = product['productImage']?.toString() ?? '';
    final price = product['productPrice'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                else
                  _imagePlaceholder(),

                Positioned(
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: militaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'BEST SELLER',
                      style: TextStyle(
                        color: cream,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textDark.withValues(alpha: 0.75),
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹$price',
                    style: const TextStyle(
                      color: Color(0xFF276B3D),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: cardGreen,
      alignment: Alignment.center,
      child: const Icon(Icons.local_cafe, color: cream, size: 42),
    );
  }
}
