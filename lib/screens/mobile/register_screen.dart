import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Logging in...')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.authError ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.shield, size: 60, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'Join DiPrep',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your emergency alert account',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'John Doe',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              enabled: !_isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email *',
                hintText: 'john@example.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              enabled: !_isLoading,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number (Optional)',
                hintText: '+63 9XX XXX XXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Location (Optional)',
                hintText: 'City, Region',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              enabled: !_isLoading,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: '••••••••',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              enabled: !_isLoading,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                hintText: '••••••••',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Account', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            // Demo mode button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Continue in Demo Mode'),
                onPressed: _isLoading
                    ? null
                    : () {
                        final auth = context.read<AuthProvider>();
                        auth.loginAsDemo();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
