import 'package:battalion_chai/users/widget/app_footer_screen.dart';
import 'package:battalion_chai/users/widget/app_header_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  static const Color bgGreen = Color(0xFF0D2B1B);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);

  final CollectionReference<Map<String, dynamic>> branchesRef =
      FirebaseFirestore.instance.collection('branches');

  bool _isBranchOpen(Map<String, dynamic> data) {
    final openTime = data['open_time']?.toString() ?? '';
    final closeTime = data['close_time']?.toString() ?? '';

    final openParts = openTime.split(':');
    final closeParts = closeTime.split(':');

    if (openParts.length != 2 || closeParts.length != 2) {
      return data['status']?.toString().toLowerCase() == 'open';
    }

    final openHour = int.tryParse(openParts[0]);
    final openMinute = int.tryParse(openParts[1]);
    final closeHour = int.tryParse(closeParts[0]);
    final closeMinute = int.tryParse(closeParts[1]);

    if (openHour == null ||
        openMinute == null ||
        closeHour == null ||
        closeMinute == null) {
      return data['status']?.toString().toLowerCase() == 'open';
    }

    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final openingMinutes = openHour * 60 + openMinute;
    final closingMinutes = closeHour * 60 + closeMinute;

    // Same opening and closing time is treated as closed.
    if (openingMinutes == closingMinutes) return false;

    // Supports branches that stay open overnight.
    if (openingMinutes < closingMinutes) {
      return currentMinutes >= openingMinutes &&
          currentMinutes < closingMinutes;
    }

    return currentMinutes >= openingMinutes || currentMinutes < closingMinutes;
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return time;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildBranchCard(Map<String, dynamic> data, bool isMobile) {
    final city = data['city_name']?.toString() ?? 'Branch';
    final address = data['address']?.toString() ?? '';
    final imageUrl = data['image']?.toString() ?? '';
    final openTime = data['open_time']?.toString() ?? '';
    final closeTime = data['close_time']?.toString() ?? '';

    final isOpen = _isBranchOpen(data);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF173A27),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cream.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch image
          SizedBox(
            height: isMobile ? 190 : 220,
            width: double.infinity,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imagePlaceholder();
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return _imagePlaceholder(loading: true);
                    },
                  )
                : _imagePlaceholder(),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City and status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        city,
                        style: const TextStyle(
                          color: cream,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? Colors.green.withValues(alpha: 0.18)
                            : Colors.red.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          color: isOpen
                              ? Colors.lightGreenAccent
                              : Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: saffron,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address.isEmpty ? 'Address not available' : address,
                        style: TextStyle(
                          color: cream.withValues(alpha: 0.85),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(color: cream.withValues(alpha: 0.15)),
                const SizedBox(height: 10),

                // Opening hours
                Row(
                  children: [
                    const Icon(Icons.access_time, color: saffron, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        openTime.isNotEmpty && closeTime.isNotEmpty
                            ? '${_formatTime(openTime)} - ${_formatTime(closeTime)}'
                            : 'Timings not available',
                        style: const TextStyle(
                          color: cream,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Location/contact action placeholder
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Add Google Maps navigation here if required.
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Branch: $city')));
                    },
                    icon: const Icon(Icons.storefront_outlined, size: 18),
                    label: const Text('VISIT BRANCH'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cream,
                      side: const BorderSide(color: saffron),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder({bool loading = false}) {
    return Container(
      color: const Color(0xFF244733),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(color: saffron)
          : const Icon(Icons.local_cafe, color: cream, size: 55),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isMobile = width < 600;
            final horizontalPadding = isMobile ? 16.0 : 36.0;

            final crossAxisCount = width >= 1100
                ? 3
                : width >= 700
                ? 2
                : 1;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: AppHeader(),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      42,
                      horizontalPadding,
                      50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'OUR BRANCHES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: saffron,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Find Your Nearest Battalion Chai',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream,
                            fontSize: isMobile ? 27 : 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Visit us for a refreshing cup of chai.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream.withValues(alpha: 0.8),
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 32),

                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: branchesRef.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Unable to load branches. Please try again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: cream),
                                ),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                  color: saffron,
                                ),
                              );
                            }

                            final docs = snapshot.data?.docs ?? [];

                            if (docs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  'No branches available right now.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: cream, fontSize: 16),
                                ),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 22,
                                    mainAxisSpacing: 22,
                                    mainAxisExtent: 475,
                                  ),
                              itemBuilder: (context, index) {
                                return _buildBranchCard(
                                  docs[index].data(),
                                  isMobile,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
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
}
