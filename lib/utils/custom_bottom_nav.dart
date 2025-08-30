// lib/widgets/custom_nav_bar.dart
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
      onTap: onTap,
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
        inherit: true, // ✅ fixes TextStyle interpolation issue
      ),
      unselectedLabelStyle: TextStyle(fontSize: fontSize, inherit: true),

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
          icon: Image.asset(
            "assets/icons/tools .png",
            height: iconSize,
          ), // ✅ remove extra space in filename
          label: "Tools",
        ),
      ],
    );
  }
}
