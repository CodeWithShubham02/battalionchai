import 'package:battalion_chai/users/widget/app_footer_screen.dart';
import 'package:battalion_chai/users/widget/app_header_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const Color bgGreen = Color(0xFF0D2B1B);
  static const Color cardGreen = Color(0xFF163C29);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);
  static const Color textDark = Color(0xFF172D20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final horizontalPadding = isMobile ? 16.0 : 36.0;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: screen ke top par
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: AppHeader(),
                  ),

                  // Main menu content
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      30,
                      horizontalPadding,
                      0,
                    ),
                    child: Column(
                      children: [
                        _buildHeading(isMobile),
                        const SizedBox(height: 24),
                        _buildProducts(
                          isMobile: isMobile,
                          availableWidth: constraints.maxWidth -
                              horizontalPadding * 2,
                        ),
                      ],
                    ),
                  ),

                  // Footer: same page ke bottom par
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                    child: AppFooter(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildHeading(bool isMobile) {
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
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 25, height: 2, color: saffron),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'BEST MENU',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cream,
            fontSize: isMobile ? 27 : 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Our most loved drinks & snacks',
          style: TextStyle(color: cream, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProducts({
    required bool isMobile,
    required double availableWidth,
  }) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _message(
            'Products load nahi ho paaye.\n${snapshot.error}',
            icon: Icons.error_outline,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(50),
            child: CircularProgressIndicator(color: saffron),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        // Sirf active aur best seller products dikhayein.
        final products = docs.where((doc) {
          final data = doc.data();
          return data['bestSeller'] == true;
        }).toList();

        // Latest products pehle.
        products.sort((a, b) {
          final aTime = a.data()['createdAt'];
          final bTime = b.data()['createdAt'];

          final aDate = aTime is Timestamp ? aTime.toDate() : DateTime(2000);

          final bDate = bTime is Timestamp ? bTime.toDate() : DateTime(2000);

          return bDate.compareTo(aDate);
        });

        if (products.isEmpty) {
          return _message(
            'Abhi koi best seller product available nahi hai.',
            icon: Icons.local_cafe_outlined,
          );
        }

        if (isMobile) {
          return SizedBox(
            height: 226,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 155,
                  child: _buildProductCard(products[index].data()),
                );
              },
            ),
          );
        }

        final cardWidth = ((availableWidth - 50) / 6).clamp(115.0, 220.0);

        return Wrap(
          spacing: 10,
          runSpacing: 16,
          children: products.map((doc) {
            return SizedBox(
              width: cardWidth,
              height: 190,
              child: _buildProductCard(doc.data()),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['productName']?.toString() ?? 'Product';
    final description = product['productDescription']?.toString() ?? '';
    final imageUrl = product['productImage']?.toString() ?? '';
    final price = product['productPrice'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
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
                if (product['bestSeller'] == true)
                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bgGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'BEST SELLER',
                        style: TextStyle(
                          color: cream,
                          fontSize: 8,
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
              padding: const EdgeInsets.fromLTRB(9, 7, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textDark.withValues(alpha: 0.85),
                      fontSize: 8.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '₹$price',
                        style: const TextStyle(
                          color: Color(0xFF276B3D),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: bgGreen,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _showProductDetails(product),
                          child: const SizedBox(
                            width: 25,
                            height: 25,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: cream,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _message(String message, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        children: [
          Icon(icon, color: cream, size: 42),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: cream),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cream,
        title: Text(
          product['productName']?.toString() ?? 'Product',
          style: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${product['productDescription'] ?? ''}\n\n'
          'Category: ${product['categoryName'] ?? ''}\n'
          'Price: ₹${product['productPrice'] ?? 0}',
          style: const TextStyle(color: textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: bgGreen)),
          ),
        ],
      ),
    );
  }
}
