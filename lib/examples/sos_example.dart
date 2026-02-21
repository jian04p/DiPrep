import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/pulsing_sos_button.dart';

/// Example implementation of the SOS Button in your app
/// 
/// To use the SOS feature in your app:
/// 1. Initialize Firebase in main()
/// 2. Add PulsingSosButton to your screen
/// 3. Ensure you have a valid userId for the current user

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (required for Firestore)
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiPrep SOS Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SosExampleScreen(),
    );
  }
}

class SosExampleScreen extends StatelessWidget {
  const SosExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, get this from your auth provider
    const String currentUserId = 'user123';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Emergency Alert System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap to activate emergency broadcast',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            
            // The SOS Button Component
            PulsingSosButton(
              userId: currentUserId,
              onSosActivated: () {
                print('SOS activated for user: $currentUserId');
                // Add any additional logic here (e.g., analytics, notifications)
              },
              onSosDeactivated: () {
                print('SOS deactivated for user: $currentUserId');
                // Add any cleanup logic here
              },
            ),
            
            const SizedBox(height: 48),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                '⚠️ When activated, your GPS location will be broadcast every 10 seconds to emergency services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
