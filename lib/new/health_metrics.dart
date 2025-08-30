import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/measurement_screen.dart';
import 'package:test_app/plan/calorie_tracker.dart';
import 'package:test_app/plan/step_screen.dart';
import 'package:test_app/new/cycle_tracker.dart';
import 'package:test_app/new/sleep_tracking.dart';
import 'package:test_app/shift/water.dart';
import 'package:test_app/theme/app_theme.dart'; // Import for theme extension access
import 'package:test_app/utils/custom_app_bars.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';

class HealthMetricsScreen extends StatelessWidget {
  const HealthMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBars.simpleAppBar(context, "Health Metrics"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              context,
              "Body Metrics",
              "assets/icons/body_metrics.png",
              const MeasurementScreen(),
            ),

            _buildMetricCard(
              context,
              "Calories",
              "assets/icons/calories.png",
               CalorieTrackerScreen(),
            ),
            _buildMetricCard(
              context,
              "Steps",
              "assets/icons/steps.png",
              const StepsScreen(),
            ),
            _buildMetricCard(
              context,
              "Sleep",
              "assets/icons/sleep.png",
             SleepTrackerScreen(),
            ),
            _buildMetricCard(
              context,
              "Water",
              "assets/icons/water.png",
              WaterIntakeScreen(),
            ),
            _buildMetricCard(
              context,
              "Cycle",
              "assets/icons/cycle.png",
              CycleTrackerScreen(),
            ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Add Ask Luna API here
          },
          backgroundColor: theme.colorScheme.primary,
          label: Text(
            "Ask Luna",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: Image.asset("assets/icons/ai.png", height: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // bottomNavigationBar: Container(
      //   height: 78,
      //   decoration: BoxDecoration(
      //     color: theme.colorScheme.onPrimary,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.08),
      //         blurRadius: 10,
      //         offset: const Offset(0, -2), // subtle shadow above navbar
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: theme.colorScheme.secondary,
      //     unselectedItemColor: theme.colorScheme.onSurfaceVariant,
      //     currentIndex: 3,
      //     selectedIconTheme: IconThemeData(
      //       color: theme.colorScheme.secondary,
      //       // bigger selected icon
      //     ),
      //     unselectedIconTheme: IconThemeData(
      //       color: theme.colorScheme.onSurfaceVariant,
      //     ),
      //     selectedLabelStyle: theme.textTheme.bodyMedium,
      //     unselectedLabelStyle: theme.textTheme.bodyMedium,
      //     onTap: (index) {
      //       // TODO: Handle navigation
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Image.asset("assets/icons/home.png", height: 26),
      //         label: "Home",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Image.asset("assets/icons/diet.png", height: 26),
      //         label: "Diet",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Image.asset("assets/icons/workout.png", height: 26),
      //         label: "Workout",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Image.asset("assets/icons/metrics.png", height: 26),
      //         label: "Metrics",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Image.asset("assets/icons/tools .png", height: 26),
      //         label: "Tools",
      //       ),
      //     ],
      //   ),
      // ⬅️ custom height
      //),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3, // example
        onTap: (index) {
          // handle navigation
        },
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String iconPath,
    Widget destination,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 44),
            const SizedBox(height: 8),
            Text(title, style: theme.textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
