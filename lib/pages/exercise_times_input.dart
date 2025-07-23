import 'package:flutter/material.dart';
import '../pages/transformation.dart';
import '../pages/goal_input.dart';

class ExerciseTimesInputPage extends StatefulWidget {
  const ExerciseTimesInputPage({super.key});

  @override
  State<ExerciseTimesInputPage> createState() => _ExerciseTimesInputPageState();
}

class _ExerciseTimesInputPageState extends State<ExerciseTimesInputPage> {
  String? selectedFrequency;

  void _submit() {
    if (selectedFrequency != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransformationInputPage()),
      );
    }
  }

  Widget _buildFrequencyOption(String frequency) {
    final isSelected = selectedFrequency == frequency;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFrequency = frequency;
        });
      },
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
            frequency,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'DM Sans',
              color: isSelected ? Colors.white : const Color(0xFF222326),
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10),
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/Group(2).png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GoalInputPage()),
                  );
                },
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.55,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFECEFEE),
                  color: const Color(0xFF0C0C0C),
                ),
              ),
            ),
            const SizedBox(height: 35),

            // Question
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "How often do you exercise?",
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

            // Frequency options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildFrequencyOption("1-2 times a week"),
                  _buildFrequencyOption("3-5 times a week"),
                  _buildFrequencyOption("Daily"),
                  _buildFrequencyOption("Never"),
                ],
              ),
            ),

            const Spacer(),

            // Next button (enabled/disabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedFrequency != null ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedFrequency != null
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
                      color: Colors.white,
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
