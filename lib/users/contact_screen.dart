import 'package:battalion_chai/users/widget/app_footer_screen.dart';
import 'package:battalion_chai/users/widget/app_header_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const Color bgGreen = Color(0xFF0D2B1B);
  static const Color cardGreen = Color(0xFF163C29);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);
  static const Color textDark = Color(0xFF172D20);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _messageController = TextEditingController();

  String _enquiryType = 'Franchise Enquiry';
  bool _isSubmitting = false;

  final List<String> _enquiryTypes = const [
    'Franchise Enquiry',
    'Business Partnership',
    'Product Related Query',
    'Feedback',
    'General Enquiry',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('userFeedback').add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'enquiryType': _enquiryType,
        'message': _messageController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'new',
      });

      if (!mounted) return;

      _nameController.clear();
      _emailController.clear();
      _mobileController.clear();
      _messageController.clear();

      setState(() {
        _enquiryType = 'Franchise Enquiry';
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your enquiry has been submitted.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to submit your enquiry. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('Contact form submission error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            final horizontalPadding = isMobile
                ? 16.0
                : constraints.maxWidth * 0.08;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: AppHeader(),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isMobile ? 30 : 48,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'GET IN TOUCH',
                          style: TextStyle(
                            color: saffron,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Let’s Talk Business',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream,
                            fontSize: isMobile ? 30 : 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Interested in a Battalion Chai franchise? '
                          'Have a question or suggestion? '
                          'Send us your enquiry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream.withValues(alpha: 0.85),
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 32),

                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 850),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isMobile ? 20 : 34),
                            decoration: BoxDecoration(
                              color: cardGreen,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: cream.withValues(alpha: 0.14),
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Send Us Your Enquiry',
                                    style: TextStyle(
                                      color: cream,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Fill in the details below and '
                                    'we will review your message.',
                                    style: TextStyle(
                                      color: cream.withValues(alpha: 0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  _label('Full Name'),
                                  const SizedBox(height: 8),
                                  _textField(
                                    controller: _nameController,
                                    hint: 'Enter your full name',
                                    icon: Icons.person_outline,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 2) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  _label('Email Address'),
                                  const SizedBox(height: 8),
                                  _textField(
                                    controller: _emailController,
                                    hint: 'Enter your email address',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      final email = value?.trim() ?? '';
                                      final emailRegex = RegExp(
                                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                      );

                                      if (!emailRegex.hasMatch(email)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  _label('Mobile Number'),
                                  const SizedBox(height: 8),
                                  _textField(
                                    controller: _mobileController,
                                    hint: 'Enter 10-digit mobile number',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      final mobile = value?.trim() ?? '';
                                      if (!RegExp(
                                        r'^[0-9]{10}$',
                                      ).hasMatch(mobile)) {
                                        return 'Enter a valid 10-digit mobile number';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  _label('Enquiry Type'),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: _enquiryType,
                                    isExpanded: true,
                                    dropdownColor: cardGreen,
                                    style: const TextStyle(color: cream),
                                    decoration: _inputDecoration(
                                      hint: 'Select enquiry type',
                                      icon: Icons.category_outlined,
                                    ),
                                    items: _enquiryTypes.map((type) {
                                      return DropdownMenuItem<String>(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _enquiryType = value);
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  _label('Message'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _messageController,
                                    maxLines: 5,
                                    maxLength: 1000,
                                    style: const TextStyle(color: cream),
                                    decoration: _inputDecoration(
                                      hint: 'Tell us about your enquiry...',
                                      icon: Icons.message_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 10) {
                                        return 'Message must be at least 10 characters';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      onPressed: _isSubmitting
                                          ? null
                                          : _submitForm,
                                      icon: _isSubmitting
                                          ? const SizedBox(
                                              width: 19,
                                              height: 19,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: bgGreen,
                                              ),
                                            )
                                          : const Icon(Icons.send_rounded),
                                      label: Text(
                                        _isSubmitting
                                            ? 'Submitting...'
                                            : 'Submit Enquiry',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: saffron,
                                        foregroundColor: bgGreen,
                                        disabledBackgroundColor: saffron
                                            .withValues(alpha: 0.6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Center(
                                    child: Text(
                                      'Your information will be used '
                                      'to respond to your enquiry.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: cream.withValues(alpha: 0.7),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: cream,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: cream),
      decoration: _inputDecoration(hint: hint, icon: icon),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cream.withValues(alpha: 0.5), fontSize: 13),
      prefixIcon: Icon(icon, color: saffron, size: 21),
      filled: true,
      fillColor: bgGreen.withValues(alpha: 0.65),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: cream.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: cream.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: saffron, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
