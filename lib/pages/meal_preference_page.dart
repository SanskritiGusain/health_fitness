import 'package:flutter/material.dart';
import '../pages/transformation.dart';
import 'medical_condition.dart';

class MealPreferencePage extends StatefulWidget {
  const MealPreferencePage({super.key});

  @override
  State<MealPreferencePage> createState() => _MealPreferencePageState();
}

class _MealPreferencePageState extends State<MealPreferencePage> {
  final Set<String> selectedMealPreferences = {};

  void _submit() {
    if (selectedMealPreferences.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicalConditionPage()),
      );
    }
  }

  Widget _buildOption(String label) {
    final isSelected = selectedMealPreferences.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedMealPreferences.remove(label); // deselect
          } else {
            selectedMealPreferences.add(label); // select
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C0C0C) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
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
      body: Stack(
        children: [
          // Back arrow
          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              icon: Image.asset(
                'assets/icons/Group(2).png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransformationInputPage()),
                );
              },
            ),
          ),

          // Progress bar
          Positioned(
            top: 115,
            left: 20,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.30,
                minHeight: 6,
                backgroundColor: const Color(0xFFECEFEE),
                color: const Color(0xFF0C0C0C),
              ),
            ),
          ),

          // Question
          const Positioned(
            top: 152,
            left: 20,
            child: Text(
              "You are?",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                height: 2.8,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Meal options
          Positioned(
            top: 230,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOption("Vegetarian"),
                _buildOption("Non- vegetarian"),
                _buildOption("Vegan"),
                _buildOption("Eggetarian"),
                _buildOption("Gluten intolerant"),
                _buildOption("Lactose intolerant"),
              ],
            ),
          ),

          // Next button
          Positioned(
            bottom: 45,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedMealPreferences.isNotEmpty ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C0C0C),
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
    );
  }
}
