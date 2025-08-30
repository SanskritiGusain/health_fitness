import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/wrapper/wrapper.dart'; // ✅ import Wrapper
import 'theme/app_theme.dart'; // Adjust path if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Fitness App',
      debugShowCheckedModeBanner: false,

      // Apply your custom themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // auto-switch with system
      // ✅ Wrapper decides: HomePage or LoginSelectionPage
      home: const Wrapper(),
    );
  }
}
