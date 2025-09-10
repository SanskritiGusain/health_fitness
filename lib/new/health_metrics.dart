import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/measurement_screen.dart';
import 'package:test_app/plan/calorie_tracker.dart';
import 'package:test_app/plan/step_screen.dart';
import 'package:test_app/new/cycle_tracker.dart';
import 'package:test_app/new/sleep_tracking.dart';
import 'package:test_app/shift/water.dart';
 // Import for theme extension access
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

      
           bottomNavigationBar: const CustomNavBar(currentIndex: 4),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String iconPath,
    Widget destination,
  ) {


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
           color: Colors.white12,
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
            Text(title, ),
          ],
        ),
      ),
    );
  }
}
