
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  static const Color green = Color(0xFF123526);
  static const Color greenLight = Color(0xFF1E503A);
  static const Color cream = Color(0xFFF6F1E5);
  static const Color orange = Color(0xFFF49A1A);
  static const Color textDark = Color(0xFF183629);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isActive = true;
  int selectedIconIndex = 0;

  final List<IconData> categoryIcons = [
    Icons.coffee_rounded,
    Icons.local_cafe_rounded,
    Icons.emoji_food_beverage_rounded,
    Icons.bakery_dining_rounded,
    Icons.fastfood_rounded,
    Icons.local_drink_rounded,
    Icons.icecream_rounded,
    Icons.restaurant_rounded,
  ];

  final List<Map<String, dynamic>> categories = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Temporary: replace with the aid of the currently logged-in admin.
  final String currentAdminAid = 'copuDpRPvsPnsTuIHtY3';
  bool isSaving = false;
  Future<void> saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    setState(() => isSaving = true);

    try {
      // Verify that this admin exists in Firestore.
      final adminSnapshot = await _firestore
          .collection('admin')
          .doc(currentAdminAid)
          .get();

      if (!adminSnapshot.exists) {
        throw Exception('Admin record not found.');
      }

      final adminData = adminSnapshot.data();

      if (adminData == null ||
          adminData['aid'] != currentAdminAid) {
        throw Exception('Admin ID verification failed.');
      }

      // Check duplicate category name in Firestore.
      final duplicateSnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (duplicateSnapshot.docs.isNotEmpty) {
        if (!mounted) return;

        Get.snackbar(
          'Duplicate Category',
          'This category already exists.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Save category in Firestore.
      await _firestore.collection('categories').add({
        'name': name,
        'description': description,
        'aid': currentAdminAid,
        'iconCodePoint': categoryIcons[selectedIconIndex].codePoint,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _nameController.clear();
      _descriptionController.clear();

      setState(() {
        selectedIconIndex = 0;
        isActive = true;
      });

      Get.snackbar(
        'Success',
        'Category saved to Firestore successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      if (!mounted) return;

      Get.snackbar(
        'Error',
        'Could not save category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }


  void deleteCategory(int index) {
    setState(() => categories.removeAt(index));

    Get.snackbar(
      'Category Removed',
      'Category removed from this screen.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Back to previous screen',
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              constraints.maxWidth < 600 ? 16 : 28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageHeading(),
                    const SizedBox(height: 24),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildFormCard()),
                          const SizedBox(width: 24),
                          Expanded(child: _buildCategoryList()),
                        ],
                      )
                    else ...[
                      _buildFormCard(),
                      const SizedBox(height: 24),
                      _buildCategoryList(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeading() {
    return Row(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.category_rounded,
            color: orange,
            size: 30,
          ),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Management',
                style: TextStyle(
                  color: textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Organize your chai and food menu categories.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return _card(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              Icons.add_circle_outline_rounded,
              'Create New Category',
            ),
            const SizedBox(height: 24),

            const Text(
              'Category Name *',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 9),

            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                hint: 'e.g. Chai, Coffee, Snacks',
                icon: Icons.drive_file_rename_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter category name';
                }
                if (categories.any(
                      (category) =>
                  (category['name'] as String).toLowerCase() ==
                      value.trim().toLowerCase(),
                )) {
                  return 'This category already exists';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 9),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration(
                hint: 'Write a short category description...',
                icon: Icons.description_outlined,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Choose Category Icon',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(categoryIcons.length, (index) {
                final selected = selectedIconIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() => selectedIconIndex = index);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected ? green : cream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? orange : Colors.black12,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      categoryIcons[index],
                      color: selected ? orange : green,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Status',
                          style: TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Make this category visible or inactive.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive,
                    activeTrackColor: green,
                    onChanged: (value) {
                      setState(() => isActive = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveCategory,
                icon: isSaving
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: green,
                  ),
                )
                    : const Icon(Icons.save_rounded),
                label: Text(
                  isSaving ? 'SAVING...' : 'SAVE CATEGORY',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _card(
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Unable to load categories. Please check Firestore rules.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _card(
            child: const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: CircularProgressIndicator(
                  color: green,
                ),
              ),
            ),
          );
        }

        final categoryDocs = snapshot.data?.docs ?? [];

        return _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _sectionTitle(
                      Icons.list_alt_rounded,
                      'Existing Categories',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${categoryDocs.length} total',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              if (categoryDocs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text('No categories added yet.'),
                  ),
                )
              else
                ...categoryDocs.map((doc) {
                  final category = doc.data();

                  final name =
                  (category['name'] ?? '').toString();

                  final description =
                  (category['description'] ?? '').toString();

                  final active =
                      category['isActive'] == true;

                  final iconCodePoint =
                  category['iconCodePoint'] as int?;

                  final categoryIcon = iconCodePoint != null
                      ? IconData(
                    iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  )
                      : Icons.category_rounded;

                  return Container(
                    key: ValueKey(doc.id),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8E0D1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            categoryIcon,
                            color: green,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                description.isEmpty
                                    ? 'No description'
                                    : description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: active
                                      ? const Color(0xFFE2F3E7)
                                      : const Color(0xFFFBE7D9),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Text(
                                  active ? 'ACTIVE' : 'INACTIVE',
                                  style: TextStyle(
                                    color: active
                                        ? green
                                        : Colors.brown,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          tooltip: 'Delete category',
                          onPressed: () {
                            _confirmDelete(doc.id, name);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }



  void _confirmDelete(String documentId, String categoryName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category?'),
          content: Text(
            'Are you sure you want to delete "$categoryName"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(documentId)
                      .delete();

                  if (!mounted) return;

                  Get.snackbar(
                    'Success',
                    'Category deleted successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  if (!mounted) return;

                  Get.snackbar(
                    'Error',
                    'Could not delete category. Check permissions.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }


  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8E0D1),
        ),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: green, size: 22),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: textDark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: green),
      filled: true,
      fillColor: const Color(0xFFFAF8F2),
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE3DDCF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE3DDCF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: green,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
