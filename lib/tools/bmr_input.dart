import 'package:flutter/material.dart';
import 'bmr_result_screen.dart';
import 'package:test_app/utils/textflied_unit_dropdown.dart';

class BMRScreenInput extends StatefulWidget {
  const BMRScreenInput({super.key});

  @override
  State<BMRScreenInput> createState() => _BMRScreenInputState();
}

class _BMRScreenInputState extends State<BMRScreenInput> {
  String? selectedGender;
  String? selectedActivityLevel;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String weightUnit = 'Kg';
  String _selectedHeightUnit = 'cm';

  final List<String> activityLevels = [
    'Sedentary (Little to no exercise)',
    'Light exercise (1–3 days a week)',
    'Moderate exercise (3–5 days a week)',
    'Heavy exercise (6–7 days a week)',
    'Athlete-level training',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BMR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade300),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 16 : 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Enter Your Information",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222326),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Gender Dropdown
                      _buildDropdownField(
                        hint: "Gender",
                        value: selectedGender,
                        items: const ['Female', 'Male'],
                        onChanged: (value) => setState(() => selectedGender = value),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Age
                      _buildTextField(_ageController, "Age"),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Height
                      CustomInputWithDropdown(
                        controller: _heightController,
                        hintText: "Height",
                        value: _selectedHeightUnit,
                        items: const ["cm", "inch"],
                        onChanged: (val) => setState(() => _selectedHeightUnit = val!),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Weight
                      CustomInputWithDropdown(
                        controller: _weightController,
                        hintText: "Weight",
                        value: weightUnit,
                        items: const ["Kg", "lbs"],
                        onChanged: (val) => setState(() => weightUnit = val!),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Activity Level Dropdown
                      _buildDropdownField(
                        hint: "Activity Level",
                        value: selectedActivityLevel,
                        items: activityLevels,
                        onChanged: (value) => setState(() => selectedActivityLevel = value),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ElevatedButton(
          onPressed: _onCalculatePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0C0C0C),
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 20 : 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Calculate",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFC9C9C9),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
    
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFFC9C9C9),
              fontSize: 14,
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _onCalculatePressed() {
    double? bmr = _calculateBMR();
    if (bmr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BmrResultScreen(bmr: bmr.round()),
        ),
      );
    }
  }

  double? _calculateBMR() {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _ageController.text.isEmpty ||
        selectedGender == null ||
        selectedActivityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return null;
    }

    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    if (height <= 0 || weight <= 0 || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return null;
    }

    if (_selectedHeightUnit == 'inch') height *= 2.54;
    if (weightUnit == 'lbs') weight *= 0.453592;

    double bmr;
    if (selectedGender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    final activityMultipliers = {
      'Sedentary (Little to no exercise)': 1.2,
      'Light exercise (1–3 days a week)': 1.375,
      'Moderate exercise (3–5 days a week)': 1.55,
      'Heavy exercise (6–7 days a week)': 1.725,
      'Athlete-level training': 1.9,
    };

    return bmr * (activityMultipliers[selectedActivityLevel!] ?? 1.2);
  }
}
