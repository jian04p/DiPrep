import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield, size: 120, color: Colors.white),
                      SizedBox(height: 24),
                      Text('DiPrep', style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Emergency Alert System', style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
