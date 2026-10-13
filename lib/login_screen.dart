
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_routes.dart';
import 'app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  String? error;


  Future<void> login() async {
    final adminId = emailController.text.trim();
    final password = passwordController.text;

    if (adminId.isEmpty || password.isEmpty) {
      setState(() => error = 'Enter admin ID and password.');
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('admin')
          .where('admin_id', isEqualTo: adminId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        if (mounted) {
          setState(() => error = 'Invalid admin ID or password.');
        }
        return;
      }

      final doc = query.docs.first;
      final data = doc.data();

      if (data['password'] != password) {
        if (mounted) {
          setState(() => error = 'Invalid admin ID or password.');
        }
        return;
      }

      if (!mounted) return;

      // Save the authenticated admin's document ID.
      Get.offAllNamed(
        AppRoutes.adminHomeScreen,
        arguments: {
          'aid': doc.id,
          'admin_id': data['admin_id'],
        },
      );
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() {
          error = 'Unable to login. Please check your connection and access.';
        });
      }
      debugPrint('Firestore login error: ${e.code} - ${e.message}');
    } catch (e) {
      if (mounted) {
        setState(() => error = 'Something went wrong. Please retry.');
      }
      debugPrint('Admin login error: $e');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shield,
                    size: 54,
                    color: AppTheme.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'OWNER PORTAL',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Admin ID',
                      hintText: 'Enter your admin ID',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onSubmitted: (_) => login(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: Text(
                        loading ? 'PLEASE WAIT...' : 'LOGIN SECURELY',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
