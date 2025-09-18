// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/day_provider.dart';
import 'package:test_app/login/login_page.dart';
import 'package:test_app/plan/fitness_wellness.dart';
import 'package:test_app/pages/user_details.dart';
import 'package:test_app/theme/app_theme.dart';
import 'package:test_app/firebase_options.dart';
import 'package:test_app/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/day_provider.dart';
import 'package:test_app/provider/week_day_provider.dart';
import 'package:test_app/tools/tools_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectedDayProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectedWeekDayProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  User? _user;
  bool _isLoading = true;
  Widget _homeScreen = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    // listen to firebase login/logout
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });

    _loadSavedTheme();
    _decideHomeScreen();
  }

  /// load saved theme
  void _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selected_theme');
    if (savedTheme != null) {
      setState(() {
        _themeMode = _getThemeMode(savedTheme);
      });
    }
  }

  /// decide first screen
Future<void> _decideHomeScreen() async {
  try {
    if (_user == null) {
      debugPrint("🚪 No Firebase user → redirecting to LoginSelectionPage");
      setState(() {
        _homeScreen = const LoginSelectionPage();
        _isLoading = false;
      });
      return;
    }

    final response = await ApiService.getRequest("user/");
    debugPrint("✅ User API Response: $response");

    final currentDiet = response['current_diet'];
    final currentWorkout = response['current_workout'];

    // Stronger debug logs
    debugPrint("🍽️ current_diet (raw) = ${currentDiet.runtimeType} → $currentDiet");
    debugPrint("💪 current_workout (raw) = ${currentWorkout.runtimeType} → $currentWorkout");

    final hasDiet = currentDiet != null && currentDiet is Map && currentDiet.isNotEmpty;
    final hasWorkout = currentWorkout != null && currentWorkout is Map && currentWorkout.isNotEmpty;

    debugPrint("✅ hasDiet = $hasDiet, hasWorkout = $hasWorkout");

    if (hasDiet && hasWorkout) {
      debugPrint("🎉 Both plans found → going to FitnessWellnessScreen");
      setState(() {
        _homeScreen = const FitnessWellnessScreen();
        _isLoading = false;
      });
    } else {
      debugPrint("⚠️ Missing plan → going to UserDetailsScreen");
      setState(() {
        _homeScreen = const UserDetailsPage(); // ✅ use the correct widget class name
        _isLoading = false;
      });
    }
  } catch (e, stack) {
    debugPrint("❌ Error fetching user plan: $e");
    debugPrint(stack.toString());
    setState(() {
      _homeScreen = const UserDetailsPage(); // ✅ corrected
      _isLoading = false;
    });
  }
}


  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Fitness App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
     
      home: const ToolsScreen(),
      //_isLoading
      //     ? const Scaffold(
      //         body: Center(child: CircularProgressIndicator()),
      //       )
      //     : _homeScreen,
    );
  }
}
