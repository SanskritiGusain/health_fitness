import 'package:flutter/material.dart';

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
  String weightUnit = 'kg';
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
          'BMR',
          style: TextStyle(color: Color(0xFF000000), fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
        // const Divider(height: 1),
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
                onChanged: (value) => setState(() => selectedGender = value),
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
                onChanged: (value) => setState(() => selectedActivityLevel = value),
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
              onPressed: () {
                try {
                  double? bmr = _calculateBMR();
                  if (bmr != null) {
                    Navigator.pushNamed(context, '/bmr-result', arguments: bmr.toInt());
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C0C0C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Calculate",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // const Divider(height: 1),
        BottomNavigationBar(
  currentIndex: 4,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  items: [
 BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/ant-design_home-outlined.png', // <-- Your image path here
    width: 24,
    height: 24,
  ),
  label: 'Home',
),

    BottomNavigationBarItem(
    icon: Image.asset(
                    'assets/icons/plan.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'My Plan',
    ),
    BottomNavigationBarItem(
    icon: Image.asset(
                'assets/icons/tabler_message.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
    icon:Image.asset(
                  'assets/icons/heroicons_trophy.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
      label: 'Merits',
    ),
    BottomNavigationBarItem(
      icon:Image.asset(
                   'assets/icons/hugeicons_tools.png', // <-- Your image path here
    width: 24,
    height: 24,
                  ),
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
        fillColor: const Color(0xFFFFFFFF),
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
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFDDE5F0)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 48, // Match height of text fields
    alignment: Alignment.center,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint, style: hintStyle),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFC9C9C9)),
        isExpanded: true,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}


  Widget _buildHeightInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5F0)),
      ),  padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 48, // Match height of text fields
    alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Height',
                hintStyle: TextStyle(fontSize: 14,color: Color.fromARGB(255, 195, 194, 194),fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              ),
            ),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: _selectedHeightUnit,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'cm', child: Text('cm')),
                DropdownMenuItem(value: 'inch', child: Text('inch')),
              ],
              onChanged: (value) => setState(() => _selectedHeightUnit = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE5F0)),
        
      ),padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 48, // Match height of text fields
    alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Weight',
                hintStyle: TextStyle(fontSize: 14,color: Color.fromARGB(255, 195, 194, 194),fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              ),
            ),
          ),
          Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: weightUnit,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'kg', child: Text('kg')),
                DropdownMenuItem(value: 'lbs', child: Text('lbs')),
              ],
              onChanged: (value) => setState(() => weightUnit = value!),
            ),
          ),
        ],
      ),
    );
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
    } else if (selectedGender == 'Female') {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age;
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
