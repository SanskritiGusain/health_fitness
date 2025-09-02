// lib/widgets/custom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/plan/fitness_wellness.dart';

import 'package:test_app/plan/workout.dart';
import 'package:test_app/body_mertics/measurement_screen.dart';
import 'package:test_app/shift/nutrition_tracker.dart';
import 'package:test_app/tools/tools_screen.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  void _navigateTo(int index, BuildContext context) {
    Widget destination;

    switch (index) {
      case 0:
        destination = const FitnessWellnessScreen();
        break;
      case 1:
        destination = const NutritionScreen();
        break;
      case 2:
        destination = const WorkoutScreen();
        break;
      case 3:
        destination = const MeasurementScreen();
        break;
      case 4:
        destination = const ToolsScreen();
        break;
      default:
        destination = const FitnessWellnessScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // 📏 Responsive sizing
    final iconSize = (screenWidth * 0.07).clamp(18.0, 28.0);
    final fontSize = (screenWidth * 0.03).clamp(10.0, 14.0);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) => _navigateTo(index, context),
      backgroundColor: theme.colorScheme.onPrimary,

      selectedItemColor: theme.colorScheme.secondary,
      unselectedItemColor: theme.colorScheme.outlineVariant,

      selectedIconTheme: IconThemeData(
        color: theme.colorScheme.secondary,
        size: iconSize,
      ),
      unselectedIconTheme: IconThemeData(
        color: theme.colorScheme.outlineVariant,
        size: iconSize,
      ),

      selectedLabelStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: fontSize),

      items: [
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/home.png", height: iconSize),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/diet.png", height: iconSize),
          label: "Diet",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/workout.png", height: iconSize),
          label: "Workout",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/metrics.png", height: iconSize),
          label: "Metrics",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/tools .png", height: iconSize),
          label: "Tools",
        ),
      ],
    );
  }
}