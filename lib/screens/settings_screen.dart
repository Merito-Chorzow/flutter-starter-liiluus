// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tryb ciemny'),
            value: isDarkTheme,
            onChanged: onThemeChanged,
          ),
        ],
      ),
    );
  }
}
