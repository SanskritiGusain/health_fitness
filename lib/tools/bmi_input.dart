import 'package:flutter/material.dart';
import 'bmi_result_screen.dart';
import 'package:test_app/utils/textflied_unit_dropdown.dart';

class BMIScreenInput extends StatefulWidget {
  const BMIScreenInput({super.key});

  @override
  State<BMIScreenInput> createState() => _BMIScreenInputState();
}

class _BMIScreenInputState extends State<BMIScreenInput> {
  String? selectedGender;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String weightUnit = 'kg';
  String _selectedHeightUnit = 'cm';

  final List<String> genders = ['Female', 'Male'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BMI',
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
                vertical: isSmallScreen ? 16 : 20,
              ),
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
                        items: genders,
                        onChanged: (val) => setState(() => selectedGender = val),
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
                        items: const ["kg", "lbs"],
                        onChanged: (val) => setState(() => weightUnit = val!),
                      ),
                      SizedBox(height: isSmallScreen ? 24 : 32),

                      const Spacer(),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _onCalculatePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C0C0C),
                          padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 20 : 24),
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
                    ],
                  ),
                ),
              ),
            );
          },
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
          hint: Text(hint, style: const TextStyle(color: Color(0xFFC9C9C9), fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFC9C9C9)),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _onCalculatePressed() {
    if (_ageController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final bmi = _calculateBMI();
    if (bmi != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BMIResultScreen(bmi: bmi)),
      );
    }
  }

  double? _calculateBMI() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);
    if (height == null || weight == null) return null;

    if (_selectedHeightUnit == 'inch') height *= 0.0254;
    else height /= 100;

    if (weightUnit == 'lbs') weight *= 0.453592;

    return weight / (height * height);
  }
}
