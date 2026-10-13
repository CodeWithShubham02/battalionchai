
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  static const Color green = Color(0xFF123526);
  static const Color greenLight = Color(0xFF1E503A);
  static const Color cream = Color(0xFFF6F1E5);
  static const Color orange = Color(0xFFF49A1A);
  static const Color textDark = Color(0xFF183629);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'title': 'Add Category', 'icon': Icons.grid_view_rounded},
    {'title': 'Add Menu', 'icon': Icons.restaurant_menu_rounded},
    {'title': 'Add Branches', 'icon': Icons.location_on_rounded},
    {'title': 'Manage Menu', 'icon': Icons.list_alt_rounded},
    {'title': 'Manage Branches', 'icon': Icons.storefront_rounded},
    {'title': 'Settings', 'icon': Icons.settings_rounded},
  ];

  void openPage(int index) {
    setState(() => selectedIndex = index);

    // Connect these navigation actions to your GetX routes.
    switch (index) {
      case 1:
        Get.toNamed('/admin/add_category_screen');
        break;
      case 2:
        Get.toNamed('/admin/add_menu_screen');
        break;
      case 3:
        Get.toNamed('/admin/add_branch_screen');
        break;
      case 4:
        Get.toNamed('/admin/add_menu_screen');
        break;
      case 5:
        Get.toNamed('/admin/add_menu_screen');
        break;
      case 6:
        Get.toNamed('/admin/add_menu_screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 400;

          if (isMobile) {
            return _buildMobileLayout();
          }

          return Row(
            children: [
              SizedBox(
                width: constraints.maxWidth < 1000 ? 200 : 235,
                child: _buildSidebar(),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _buildDashboardContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // MOBILE LAYOUT
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text(
          'BATTALION CHAI',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: green,
        child: SafeArea(child: _buildSidebar()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildDashboardContent(),
      ),
    );
  }

  // SIDEBAR
  Widget _buildSidebar() {
    return Container(
      color: green,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 12, 26),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: orange, width: 2),
                    color: greenLight,
                  ),
                  child: const Icon(
                    Icons.local_cafe_rounded,
                    color: orange,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BATTALION CHAI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'देश के जवानों की चाय',
                        style: TextStyle(
                          color: Color(0xFFF2E5C8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ...List.generate(menuItems.length, (index) {
            final item = menuItems[index];
            final selected = selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: Material(
                color: selected ? orange : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => openPage(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: selected ? green : Colors.white,
                          size: 21,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: TextStyle(
                              color: selected ? green : Colors.white,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          const Icon(
            Icons.local_cafe_rounded,
            color: orange,
            size: 76,
          ),
          const SizedBox(height: 8),
          const Text(
            'Ek Cup\nDesh Ke Naam',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF2E5C8),
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // TOP BAR
  Widget _buildTopBar() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: green,
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'You are all caught up!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const CircleAvatar(
            backgroundColor: Color(0xFFF2E5C8),
            child: Icon(
              Icons.person,
              color: green,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Owner',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // DASHBOARD CONTENT
  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeSection(),
        const SizedBox(height: 26),

        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 1050
                ? 4
                : constraints.maxWidth > 600
                ? 2
                : 1;

            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: columns == 1 ? 3.1 : 1.8,
              children: [
                _statCard(
                  title: 'Total Categories',
                  value: '5',
                  icon: Icons.coffee_rounded,
                  color: greenLight,
                  subtitle: 'Drink categories',
                ),
                _statCard(
                  title: 'Total Menu Items',
                  value: '18',
                  icon: Icons.restaurant_menu_rounded,
                  color: orange,
                  subtitle: 'Available products',
                ),
                _statCard(
                  title: 'Total Branches',
                  value: '5',
                  icon: Icons.storefront_rounded,
                  color: green,
                  subtitle: 'Store locations',
                ),
                _statCard(
                  title: 'Total Products',
                  value: '18',
                  icon: Icons.inventory_2_rounded,
                  color: const Color(0xFF5799C4),
                  subtitle: 'Listed in catalogue',
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 30),

        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: textDark,
          ),
        ),
        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 850
                ? 3
                : constraints.maxWidth > 500
                ? 2
                : 1;

            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: columns == 1 ? 3.0 : 2.2,
              children: [
                _quickAction(
                  title: 'Add Category',
                  subtitle: 'Create food/drink category',
                  icon: Icons.grid_view_rounded,
                  color: green,
                  onTap: () => openPage(1),
                ),
                _quickAction(
                  title: 'Add Menu',
                  subtitle: 'Add a new chai or snack',
                  icon: Icons.restaurant_menu_rounded,
                  color: orange,
                  onTap: () => openPage(2),
                ),
                _quickAction(
                  title: 'Add Branches',
                  subtitle: 'Register a new outlet',
                  icon: Icons.storefront_rounded,
                  color: green,
                  onTap: () => openPage(3),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 28),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return Column(
                children: [
                  _buildSalesCard(),
                  const SizedBox(height: 18),
                  _buildRecentMenuCard(),
                  const SizedBox(height: 18),
                  _buildRecentBranchesCard(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildSalesCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildRecentMenuCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildRecentBranchesCard()),
              ],
            );
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 500;

        return Row(
          children: [
            const Icon(
              Icons.local_cafe_rounded,
              color: green,
              size: 44,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back, Admin!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Here's what's happening with your Battalion Chai.",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!compact)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_month, color: green),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('13 Oct 2026'),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_circle_right_rounded,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesCard() {
    final values = [100.0, 125.0, 82.0, 136.0, 174.0, 105.0, 130.0];
    final days = ['7 Oct', '8 Oct', '9 Oct', '10 Oct', '11 Oct', '12 Oct', '13 Oct'];

    return _panel(
      title: 'Sales Overview',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Last 7 Days',
              style: TextStyle(color: green, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: values[index],
                          constraints: const BoxConstraints(maxHeight: 160),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: const TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMenuCard() {
    final items = [
      ['Normal Chai', 'Tea', '₹10', Icons.coffee],
      ['Masala Chai', 'Tea', '₹12', Icons.coffee],
      ['Ginger Chai', 'Tea', '₹12', Icons.local_cafe],
      ['Samosa', 'Snacks', '₹15', Icons.fastfood],
      ['Bun Maska', 'Snacks', '₹30', Icons.bakery_dining],
    ];

    return _panel(
      title: 'Recent Menu Items',
      icon: Icons.restaurant_menu_rounded,
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item[3] as IconData,
                    color: green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item[0] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        item[1] as String,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item[2] as String,
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentBranchesCard() {
    final branches = [
      ['Delhi', 'Connaught Place, New Delhi'],
      ['Mumbai', 'Andheri West, Mumbai'],
      ['Bangalore', 'Koramangala, Bangalore'],
      ['Pune', 'Kalyani Nagar, Pune'],
      ['Jaipur', 'Vaishali Nagar, Jaipur'],
    ];

    return _panel(
      title: 'Recent Branches',
      icon: Icons.storefront_rounded,
      child: Column(
        children: branches.map((branch) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        branch[1],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _panel({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E0D1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: green, size: 21),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 26, color: Color(0xFFE8E0D1)),
          child,
        ],
      ),
    );
  }
}
