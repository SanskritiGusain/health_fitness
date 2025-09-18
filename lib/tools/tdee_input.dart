import 'package:flutter/material.dart';
import 'package:test_app/tools/tdee_result_screen.dart';
import 'package:test_app/utils/textflied_unit_dropdown.dart';

class TDEEScreenInput extends StatefulWidget {
  const TDEEScreenInput({super.key});

  @override
  State<TDEEScreenInput> createState() => _TDEEScreenInputState();
}

class _TDEEScreenInputState extends State<TDEEScreenInput> {
  String? selectedGender;
  String? selectedActivityLevel;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String weightUnit = 'kg';
  String _selectedHeightUnit = 'cm';

  final List<String> activityLevels = [
    'Sedentary (Little to no exercise)',
    'Light exercise (1–3 days a week)',
    'Moderate exercise (3–5 days a week)',
    'Heavy exercise (6–7 days a week)',
    'Athlete-level training',
  ];

  final List<String> weightUnits = ['kg', 'lbs'];
  final List<String> heightUnits = ['cm', 'inch'];

  void _calculateTDEE() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);
    final int? age = int.tryParse(_ageController.text);

    if (height == null || weight == null || age == null || selectedGender == null || selectedActivityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    double heightInCm = height;
    if (_selectedHeightUnit == 'inch') {
      heightInCm = height * 2.54;
    }

    double weightInKg = weight;
    if (weightUnit == 'lbs') {
      weightInKg = weight * 0.453592;
    }

    double bmr;
    if (selectedGender == 'Male') {
      bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * age + 5;
    } else {
      bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * age - 161;
    }

    double activityFactor;
    switch (selectedActivityLevel) {
      case 'Sedentary (Little to no exercise)':
        activityFactor = 1.2;
        break;
      case 'Light exercise (1–3 days a week)':
        activityFactor = 1.375;
        break;
      case 'Moderate exercise (3–5 days a week)':
        activityFactor = 1.55;
        break;
      case 'Heavy exercise (6–7 days a week)':
        activityFactor = 1.725;
        break;
      case 'Athlete-level training':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.2;
    }

    double tdee = bmr * activityFactor;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TdeeResultScreen(tdee: tdee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF000000)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TDEE',
          style: TextStyle(color: Color(0xFF000000), fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Enter Your Information",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222326),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildSimpleDropdown(
                hint: "Gender",
                value: selectedGender,
                items: const ['Female', 'Male', 'Other'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSimpleInput(_ageController, "Age"),
              const SizedBox(height: 16),
              CustomInputWithDropdown(
                controller: _weightController,
                hintText: "Weight",
                value: weightUnit,
                items: weightUnits,
                onChanged: (val) => setState(() => weightUnit = val!),
              ),
              const SizedBox(height: 16),
              CustomInputWithDropdown(
                controller: _heightController,
                hintText: "Height",
                value: _selectedHeightUnit,
                items: heightUnits,
                onChanged: (val) => setState(() => _selectedHeightUnit = val!),
              ),
              const SizedBox(height: 16),
              _buildSimpleDropdown(
                hint: "Activity Level",
                value: selectedActivityLevel,
                items: activityLevels,
                onChanged: (String? value) {
                  setState(() {
                    selectedActivityLevel = value;
                  });
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ElevatedButton(
              onPressed: _calculateTDEE,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C0C0C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Calculate",
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFC9C9C9),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
          border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildSimpleDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
 
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFC9C9C9),
              fontWeight: FontWeight.w500,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFC9C9C9)),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}