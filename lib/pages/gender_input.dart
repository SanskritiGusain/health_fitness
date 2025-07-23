import 'package:flutter/material.dart';
import 'height_input.dart';
import '../pages/age_input.dart';

class GenderInputPage extends StatefulWidget {
  const GenderInputPage({super.key});

  @override
  State<GenderInputPage> createState() => _GenderInputPageState();
}

class _GenderInputPageState extends State<GenderInputPage> {
  String? selectedGender;
  bool _isButtonEnabled = false;

  void _submit() {
    if (selectedGender != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HeightInputPage()),
      );
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = selectedGender != null;
    });
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
          _updateButtonState();
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
            gender,
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
                  MaterialPageRoute(builder: (context) => const AgeInputPage()),
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
              "Choose Your Gender",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                height: 2.8,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Gender options
          Positioned(
            top: 230,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGenderOption("Male"),
                _buildGenderOption("Female"),
                _buildGenderOption("Other"),
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
                onPressed: _isButtonEnabled ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
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
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
