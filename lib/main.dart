// lib/main.dart
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatefulWidget {
  const GeoJournalApp({super.key});

  @override
  State<GeoJournalApp> createState() => _GeoJournalAppState();
}

class _GeoJournalAppState extends State<GeoJournalApp> {
  bool _isDarkTheme = false;

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          isDarkTheme: _isDarkTheme,
          onThemeChanged: (value) {
            setState(() {
              _isDarkTheme = value;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      home: Builder(
        builder: (context) {
          return HomeScreen(
            onOpenSettings: () => _openSettings(context),
          );
        },
      ),
    );
  }
}
