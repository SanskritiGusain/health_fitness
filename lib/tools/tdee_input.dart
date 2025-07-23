import 'package:flutter/material.dart';

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

    Navigator.pushNamed(
      context,
      '/tdee-result',
      arguments: tdee,
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
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
              _buildDropdownField(
                hint: "Gender",
                hintStyle: const TextStyle(color: Color(0xFFC9C9C9), fontSize: 14, fontWeight: FontWeight.w500),
                value: selectedGender,
                items: const ['Female', 'Male', 'Other'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(_ageController, "Age", TextInputType.number),
              const SizedBox(height: 16),
              _buildWeightInputField(),
              const SizedBox(height: 16),
              _buildHeightInputField(),
              const SizedBox(height: 16),
              _buildDropdownField(
                hint: "Activity Level",
                hintStyle: const TextStyle(color: Color(0xFFC9C9C9), fontSize: 14, fontWeight: FontWeight.w500),
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
                backgroundColor: Color(0xFF0C0C0C),
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
          const Divider(height: 1),
          BottomNavigationBar(
            currentIndex: 4,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/ant-design_home-outlined.png', width: 24, height: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/plan.png', width: 24, height: 24),
                label: 'My Plan',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/tabler_message.png', width: 24, height: 24),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/heroicons_trophy.png', width: 24, height: 24),
                label: 'Merits',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/hugeicons_tools.png', width: 24, height: 24),
                label: 'Tools',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFC9C9C9), fontSize: 14, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0C0C0C)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required TextStyle hintStyle,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5F0)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint, style: hintStyle),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle,
          isDense: true,
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildHeightInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Height',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: _selectedHeightUnit,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFC9C9C9)),
              items: const [
                DropdownMenuItem(
                  value: 'cm',
                  child: Text('cm', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                DropdownMenuItem(
                  value: 'inch',
                  child: Text('inch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedHeightUnit = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Weight',
                hintStyle: TextStyle(color: Color(0xFFC9C9C9), fontSize: 14, fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: weightUnit,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFC9C9C9)),
              items: const [
                DropdownMenuItem(
                  value: 'kg',
                  child: Text('kg', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                DropdownMenuItem(
                  value: 'lbs',
                  child: Text('lbs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  weightUnit = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
