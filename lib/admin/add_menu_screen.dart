
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  static const Color green = Color(0xFF123526);
  static const Color cream = Color(0xFFF6F1E5);
  static const Color orange = Color(0xFFF49A1A);
  static const Color textDark = Color(0xFF183629);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productImageController = TextEditingController();
  final productPriceController = TextEditingController();

  String? selectedCategoryId;
  String? selectedCategoryName;

  bool bestSeller = false;
  bool isActive = true;
  bool isSaving = false;

  // Replace this with the verified aid of the logged-in admin.
  final String currentAdminAid = 'copuDpRPvsPnsTuIHtY3';

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productImageController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoryId == null ||
        selectedCategoryName == null) {
      Get.snackbar(
        'Category Required',
        'Please select a category first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final price = double.tryParse(
      productPriceController.text.trim(),
    );

    if (price == null || price < 0) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid product price.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // Verify the selected category still exists.
      final categoryDoc = await firestore
          .collection('categories')
          .doc(selectedCategoryId)
          .get();

      if (!categoryDoc.exists) {
        throw Exception('Selected category no longer exists.');
      }

      final categoryData = categoryDoc.data()!;

      if (categoryData['isActive'] != true) {
        throw Exception('Please select an active category.');
      }

      // Verify admin document.
      final adminDoc = await firestore
          .collection('admin')
          .doc(currentAdminAid)
          .get();

      if (!adminDoc.exists ||
          adminDoc.data()?['aid'] != currentAdminAid) {
        throw Exception('Admin verification failed.');
      }

      // Save product in Firestore.
      await firestore.collection('products').add({
        'categoryId': selectedCategoryId,
        'categoryName': categoryData['name'],
        'productName': productNameController.text.trim(),
        'productImage': productImageController.text.trim(),
        'productDescription':
        productDescriptionController.text.trim(),
        'productPrice': price,
        'bestSeller': bestSeller,
        'status': isActive ? 'active' : 'inactive',
        'aid': currentAdminAid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      productNameController.clear();
      productDescriptionController.clear();
      productImageController.clear();
      productPriceController.clear();

      setState(() {
        bestSeller = false;
        isActive = true;
      });

      Get.snackbar(
        'Success',
        'Product saved to Firestore successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      if (!mounted) return;

      Get.snackbar(
        'Save Failed',
        e.toString().replaceFirst('Exception: ', ''),
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

  Future<void> deleteProduct(
      String documentId,
      String productName,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text('Delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await firestore.collection('products').doc(documentId).delete();

      Get.snackbar(
        'Success',
        'Product deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to delete product. Check permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
          'Add Menu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 950;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              constraints.maxWidth < 600 ? 16 : 28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeading(),
                    const SizedBox(height: 24),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildProductForm()),
                          const SizedBox(width: 24),
                          Expanded(child: _buildProductList()),
                        ],
                      )
                    else ...[
                      _buildProductForm(),
                      const SizedBox(height: 24),
                      _buildProductList(),
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

  Widget _buildHeading() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
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
                'Menu Management',
                style: TextStyle(
                  color: textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Add and manage your Battalion Chai products.',
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

  Widget _buildProductForm() {
    return _panel(
      title: 'Add New Product',
      icon: Icons.add_circle_outline_rounded,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Select Category *'),
            const SizedBox(height: 8),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestore
                  .collection('categories')
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    'Unable to load categories. Check Firestore rules.',
                    style: TextStyle(color: Colors.red),
                  );
                }

                if (!snapshot.hasData) {
                  return const LinearProgressIndicator(
                    color: green,
                  );
                }

                final categoryDocs = snapshot.data!.docs;

                if (categoryDocs.isEmpty) {
                  return const Text(
                    'No active categories found. Add a category first.',
                    style: TextStyle(color: Colors.red),
                  );
                }

                final validIds = categoryDocs.map((doc) => doc.id).toSet();

                if (selectedCategoryId != null &&
                    !validIds.contains(selectedCategoryId)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        selectedCategoryId = null;
                        selectedCategoryName = null;
                      });
                    }
                  });
                }

                return DropdownButtonFormField<String>(
                  value: validIds.contains(selectedCategoryId)
                      ? selectedCategoryId
                      : null,
                  isExpanded: true,
                  decoration: _inputDecoration(
                    hint: 'Choose a category',
                    icon: Icons.category_rounded,
                  ),
                  items: categoryDocs.map((doc) {
                    final data = doc.data();
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(
                        (data['name'] ?? 'Unnamed Category').toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  validator: (value) =>
                  value == null ? 'Please select a category' : null,
                  onChanged: (value) {
                    final selectedDoc = categoryDocs.firstWhereOrNull(
                          (doc) => doc.id == value,
                    );

                    setState(() {
                      selectedCategoryId = value;
                      selectedCategoryName =
                          selectedDoc?.data()['name']?.toString();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 18),
            _label('Product Name *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: productNameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration(
                hint: 'e.g. Masala Chai',
                icon: Icons.local_cafe_rounded,
              ),
              validator: (value) =>
              value == null || value.trim().isEmpty
                  ? 'Enter product name'
                  : null,
            ),

            const SizedBox(height: 18),
            _label('Product Description'),
            const SizedBox(height: 8),
            TextFormField(
              controller: productDescriptionController,
              maxLines: 3,
              decoration: _inputDecoration(
                hint: 'Describe your product...',
                icon: Icons.description_outlined,
              ),
            ),

            const SizedBox(height: 18),
            _label('Product Image URL'),
            const SizedBox(height: 8),
            TextFormField(
              controller: productImageController,
              keyboardType: TextInputType.url,
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(
                hint: 'https://example.com/product.jpg',
                icon: Icons.image_outlined,
              ),
            ),

            if (productImageController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: productImageController.text.trim(),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: green),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 70,
                    child: Center(
                      child: Text('Image could not be loaded.'),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 18),
            _label('Product Price (₹) *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: productPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _inputDecoration(
                hint: 'e.g. 20',
                icon: Icons.currency_rupee_rounded,
              ),
              validator: (value) {
                final price = double.tryParse(value?.trim() ?? '');
                if (price == null || price < 0) {
                  return 'Enter a valid price';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            _switchTile(
              title: 'Best Seller',
              subtitle: 'Highlight this product as popular',
              value: bestSeller,
              onChanged: (value) => setState(() => bestSeller = value),
            ),

            const SizedBox(height: 10),
            _switchTile(
              title: 'Product Status',
              subtitle: isActive
                  ? 'Product is active'
                  : 'Product is inactive',
              value: isActive,
              onChanged: (value) => setState(() => isActive = value),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveProduct,
                icon: isSaving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: green,
                  ),
                )
                    : const Icon(Icons.save_rounded),
                label: Text(
                  isSaving ? 'SAVING...' : 'SAVE PRODUCT',
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
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _panel(
            title: 'Existing Products',
            icon: Icons.inventory_2_rounded,
            child: const Text(
              'Unable to load products. Check Firestore rules.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return _panel(
            title: 'Existing Products',
            icon: Icons.inventory_2_rounded,
            child: const Center(
              child: CircularProgressIndicator(color: green),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return _panel(
          title: 'Existing Products',
          icon: Icons.inventory_2_rounded,
          trailing: '${docs.length} total',
          child: docs.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No products added yet.')),
          )
              : Column(
            children: docs.map((doc) {
              final data = doc.data();
              final name =
              (data['productName'] ?? 'Unnamed Product').toString();
              final categoryName =
              (data['categoryName'] ?? 'Uncategorized').toString();
              final description =
              (data['productDescription'] ?? '').toString();
              final imageUrl =
              (data['productImage'] ?? '').toString();
              final price = data['productPrice'];
              final isBestSeller = data['bestSeller'] == true;
              final active = data['status'] == 'active';

              return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.startsWith('https://') ||
                          imageUrl.startsWith('http://')
                          ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            _productPlaceholder(),
                      )
                          : _productPlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            categoryName,
                            style: const TextStyle(
                              color: green,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _badge(
                                '₹${price ?? 0}',
                                green,
                                Colors.white,
                              ),
                              if (isBestSeller)
                                _badge(
                                  'BEST SELLER',
                                  orange,
                                  green,
                                ),
                              _badge(
                                active ? 'ACTIVE' : 'INACTIVE',
                                active
                                    ? const Color(0xFFE2F3E7)
                                    : const Color(0xFFFBE7D9),
                                active ? green : Colors.brown,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete product',
                      onPressed: () => deleteProduct(doc.id, name),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _productPlaceholder() {
    return Container(
      width: 65,
      height: 65,
      color: cream,
      child: const Icon(
        Icons.local_cafe_rounded,
        color: green,
        size: 30,
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _panel({
    required String title,
    required IconData icon,
    required Widget child,
    String? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0D1)),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              if (trailing != null)
                Text(
                  trailing,
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
    );
  }

  Widget _badge(String text, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
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
    );
  }
}
