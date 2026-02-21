import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray800,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Use system theme'),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (_) => themeProvider.setSystemMode(),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Light mode'),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (_) => themeProvider.setLightMode(),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark mode'),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (_) => themeProvider.setDarkMode(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray800,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('DiPrep Emergency App'),
              subtitle: const Text('Stay ready, not scared.'),
            ),
          ),
        ],
      ),
    );
  }
}
