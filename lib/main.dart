import 'package:flutter/material.dart';
import 'package:test_app/login/login_page.dart';
import 'package:test_app/pages/location_select.dart';
import 'package:test_app/plan/step_screen.dart';
import 'package:test_app/profile/setting_screen.dart';
import 'package:test_app/tools/health_connect_intro.dart';
import 'theme/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Fitness App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: LocationSelectionPage(), // start with your SettingsPage
    );
  }
}
