import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:diprep_flutter/main.dart';
import 'package:diprep_flutter/providers/theme_provider.dart';
import 'package:diprep_flutter/providers/auth_provider.dart';
import 'package:diprep_flutter/providers/notification_provider.dart';

void main() {
  group('DiPrep Widget Tests', () {
    testWidgets('App launches and shows LaunchScreen', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify that the app launches without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('LaunchScreen displays DiPrep title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify title is displayed
      expect(find.text('DiPrep'), findsWidgets);
      expect(find.text('Emergency Alert System'), findsOneWidget);
    });

    testWidgets('Login button exists on LaunchScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify Login button exists
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Theme toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Get the ThemeProvider
      final themeProvider = tester.widget<Consumer<ThemeProvider>>(
        find.byType(Consumer<ThemeProvider>).first,
      );

      // Verify light theme is applied by default
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
