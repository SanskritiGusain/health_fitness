import 'package:flutter/material.dart';
import '../pages/desired_weight.dart';
import '../pages/drop_weight.dart';

class MotivationInput extends StatefulWidget {
  const MotivationInput({super.key});

  @override
  State<MotivationInput> createState() => _MotivationInputState();
}

class _MotivationInputState extends State<MotivationInput> {
  Set<String> selectedMotivationPreferences = {};

  void _submit() {
    if (selectedMotivationPreferences.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DesiredWeight()),
      );
    }
  }

  Widget _buildOption(String label) {
    final isSelected = selectedMotivationPreferences.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedMotivationPreferences.remove(label);
          } else {
            selectedMotivationPreferences.add(label);
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
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF222326),
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
              onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DropWeight(),
                        ),
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
          Positioned(
            top: 152,
            left: 20,
            child: const Text(
              "What usually makes you lose\nmotivation?",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Options
          Positioned(
            top: 240,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOption("I don’t see quick results"),
                _buildOption("I forget or get busy"),
                _buildOption("I feel tired or low on energy"),
                _buildOption("I get bored or lose interest"),
                _buildOption("The routine feels too strict or hard"),
              ],
            ),
          ),

          // Next button (enable/disable)
          Positioned(
            bottom: 45,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedMotivationPreferences.isNotEmpty ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMotivationPreferences.isNotEmpty
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
    );
  }
}
