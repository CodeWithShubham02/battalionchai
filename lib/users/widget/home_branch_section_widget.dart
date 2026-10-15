import 'package:battalion_chai/users/branch_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBranchesSection extends StatelessWidget {
  const HomeBranchesSection({super.key});

  static const Color green = Color(0xFF203A2A);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);

  final String _branchesCollection = 'branches';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: cream,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _intro(context, true),
                    const SizedBox(height: 24),
                    _branchList(true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.30,
                      child: _intro(context, false),
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: _branchList(false)),
                  ],
                );
        },
      ),
    );
  }

  Widget _intro(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.horizontal_rule, color: saffron, size: 22),
            SizedBox(width: 6),
            Text(
              'OUR BRANCHES',
              style: TextStyle(
                color: green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.horizontal_rule, color: saffron, size: 22),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'FIND A BATTALION CHAI NEAR YOU',
          style: TextStyle(
            color: green,
            fontSize: isMobile ? 28 : 25,
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Visit our outlets across the country and experience the real taste of Battalion Chai.',
          style: TextStyle(color: green, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => Get.to(() => const BranchScreen()),
          icon: const Icon(Icons.location_on, size: 18),
          label: const Text('View All Branches'),
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            foregroundColor: cream,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _branchList(bool isMobile) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(_branchesCollection)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Unable to load branches.',
            style: TextStyle(color: green),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: green));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Branches coming soon!',
              style: TextStyle(color: green),
            ),
          );
        }

        // Home page par maximum 4 branches.
        final visibleDocs = docs.take(4).toList();

        if (isMobile) {
          return SizedBox(
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: visibleDocs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 220,
                  child: _branchCard(visibleDocs[index].data()),
                );
              },
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 3 * 12) / 4;

            return SizedBox(
              height: 235,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(visibleDocs.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == visibleDocs.length - 1 ? 0 : 12,
                    ),
                    child: SizedBox(
                      width: cardWidth,
                      child: _branchCard(visibleDocs[index].data()),
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  Widget _branchCard(Map<String, dynamic> data) {
    final city = data['city_name']?.toString() ?? 'Branch';
    final address = data['address']?.toString() ?? '';
    final imageUrl = data['image']?.toString() ?? '';
    final openTime = data['open_time']?.toString() ?? '';
    final closeTime = data['close_time']?.toString() ?? '';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => const BranchScreen()),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: green.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 105,
                width: double.infinity,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      )
                    : _imageFallback(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 15, color: green),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: green.withValues(alpha: 0.85),
                            fontSize: 10,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$openTime - $closeTime',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: green, fontSize: 9),
                            ),
                          ),
                          Container(
                            width: 23,
                            height: 23,
                            decoration: const BoxDecoration(
                              color: green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: cream,
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
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: green,
      alignment: Alignment.center,
      child: const Icon(Icons.local_cafe, size: 35, color: cream),
    );
  }
}
