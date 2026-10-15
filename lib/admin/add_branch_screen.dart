import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;

  bool _isSaving = false;

  // Battalion Chai theme colors
  static const Color militaryGreen = Color(0xFF203A2A);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);

  // Existing admin ID
  static const String currentAdminAid = 'copuDpRPvsPnsTuIHtY3';

  @override
  void dispose() {
    _imageUrlController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;

  // Calculate current branch status from opening and closing time.
  String _getStatus() {
    if (_openTime == null || _closeTime == null) {
      return 'close';
    }

    final opening = _minutes(_openTime!);
    final closing = _minutes(_closeTime!);
    final current = _minutes(TimeOfDay.now());

    if (opening == closing) return 'close';

    final isOpen = opening < closing
        ? current >= opening && current < closing
        : current >= opening || current < closing;

    return isOpen ? 'open' : 'close';
  }

  bool _isValidImageUrl(String value) {
    final uri = Uri.tryParse(value.trim());

    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  Future<void> _pickTime({required bool isOpening}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isOpening
          ? (_openTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_closeTime ?? const TimeOfDay(hour: 22, minute: 0)),
    );

    if (selectedTime != null && mounted) {
      setState(() {
        if (isOpening) {
          _openTime = selectedTime;
        } else {
          _closeTime = selectedTime;
        }
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : militaryGreen,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label required hai';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: militaryGreen),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: militaryGreen, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _imageUrlController,
      builder: (context, value, child) {
        final url = value.text.trim();

        if (url.isEmpty || !_isValidImageUrl(url)) {
          return Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: militaryGreen.withValues(alpha: 0.2)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 48,
                  color: militaryGreen,
                ),
                SizedBox(height: 10),
                Text(
                  'Branch Image Preview',
                  style: TextStyle(
                    color: militaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Paste image URL below',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            url,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return Container(
                height: 180,
                alignment: Alignment.center,
                color: cream,
                child: const CircularProgressIndicator(color: militaryGreen),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                color: cream,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.red,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Image load nahi hui.\nDirect image URL check karein.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeTile({
    required String label,
    required TimeOfDay? time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: militaryGreen),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                time == null ? 'Select time' : time.format(context),
                style: const TextStyle(
                  color: militaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveBranch() async {
    if (!_formKey.currentState!.validate()) return;

    if (_openTime == null || _closeTime == null) {
      _showMessage('Opening aur closing time select karein.', isError: true);
      return;
    }

    if (!_isValidImageUrl(_imageUrlController.text)) {
      _showMessage('Valid image URL enter karein.', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final branches = FirebaseFirestore.instance.collection('branches');

      final branchDoc = branches.doc();

      await branchDoc.set({
        'branchId': branchDoc.id,
        'image': _imageUrlController.text.trim(),
        'city_name': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        'open_time': _formatTime(_openTime),
        'close_time': _formatTime(_closeTime),
        'status': _getStatus(),
        'aid': currentAdminAid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showMessage('Branch successfully add ho gayi!');

      _formKey.currentState!.reset();

      _imageUrlController.clear();
      _cityController.clear();
      _addressController.clear();

      setState(() {
        _openTime = null;
        _closeTime = null;
      });
    } catch (e) {
      if (mounted) {
        _showMessage('Branch save nahi hui: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Add Branch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: militaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Branch Details',
                          style: TextStyle(
                            color: militaryGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Add your Battalion Chai branch information.',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 22),

                        // Image preview
                        _buildImagePreview(),

                        const SizedBox(height: 16),

                        // Paste image URL
                        _buildTextField(
                          label: 'Branch Image URL',
                          hint: 'Paste Google Drive image URL',
                          icon: Icons.link,
                          controller: _imageUrlController,
                          keyboardType: TextInputType.url,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Image URL required hai';
                            }

                            if (!_isValidImageUrl(value)) {
                              return 'Valid image URL enter karein';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          'Note: Image URL publicly accessible hona chahiye.',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          label: 'City Name',
                          hint: 'e.g. Mumbai',
                          icon: Icons.location_city,
                          controller: _cityController,
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          label: 'Branch Address',
                          hint: 'Enter complete branch address',
                          icon: Icons.location_on_outlined,
                          controller: _addressController,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          'Branch Timing',
                          style: TextStyle(
                            color: militaryGreen,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildTimeTile(
                              label: 'Opening Time',
                              time: _openTime,
                              icon: Icons.wb_sunny_outlined,
                              onTap: () => _pickTime(isOpening: true),
                            ),
                            const SizedBox(width: 12),
                            _buildTimeTile(
                              label: 'Closing Time',
                              time: _closeTime,
                              icon: Icons.nightlight_outlined,
                              onTap: () => _pickTime(isOpening: false),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        if (_openTime != null && _closeTime != null)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatus() == 'open'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _getStatus() == 'open'
                                      ? Colors.green.shade800
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Current status: '
                                  '${_getStatus().toUpperCase()}',
                                  style: const TextStyle(
                                    color: militaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : _saveBranch,
                            icon: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add_business),
                            label: Text(
                              _isSaving ? 'Saving Branch...' : 'Add Branch',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: saffron,
                              foregroundColor: militaryGreen,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
