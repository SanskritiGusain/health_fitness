import 'package:flutter/material.dart';
import 'location_select.dart';
import '../pages/exercise_times_input.dart';

class GoalInputPage extends StatefulWidget {
  const GoalInputPage({super.key});

  @override
  State<GoalInputPage> createState() => _GoalInputPageState();
}

class _GoalInputPageState extends State<GoalInputPage> {
  final List<String> allGoals = [
    "Weight loss",
    "Balanced weight",
    "Just stay healthy",
    "Improve stamina",
  ];

  final List<String> selectedGoals = [];

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  void _submit() {
    if (selectedGoals.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExerciseTimesInputPage()),
      );
    }
  }

  Widget _buildGoalOption(String goal) {
    final isSelected = selectedGoals.contains(goal);
    return GestureDetector(
      onTap: () => _toggleGoal(goal),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C0C0C) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            goal,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'DM Sans',
              color:
                  isSelected
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF222326),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, bottom: 10),
            //   child: IconButton(
            //     icon: Image.asset(
            //       'assets/icons/Group(2).png',
            //       width: 24,
            //       height: 24,
            //     ),
            //     // onPressed: () {
            //     //   Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(builder: (context) => LocationSelectionPage()),
            //     //   );
            //     // },
            //   ),
            // ),

            // // Progress bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(4),
            //     child: LinearProgressIndicator(
            //       value: 0.55,
            //       minHeight: 6,
            //       backgroundColor: const Color(0xFFECEFEE),
            //       color: const Color(0xFF0C0C0C),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 35),

            // Question
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "What is your goal",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 20,
                  height: 2.8,
                  color: Color(0xFF222326),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Goal options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: allGoals.map(_buildGoalOption).toList()),
            ),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedGoals.isNotEmpty ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedGoals.isNotEmpty
                            ? const Color(0xFF0C0C0C)
                            : const Color(0xFF7F8180),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
