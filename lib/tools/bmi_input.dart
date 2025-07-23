

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BMI',
         style: TextStyle(color: Color(0xFF000000),fontSize: 20, fontWeight: FontWeight.w600,),
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
                 hintStyle: TextStyle(
      color: Color(0xFFC9C9C9),
    ),
    
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
                double? bmi = _calculateBMI();
                if (bmi != null) {
                  Navigator.pushNamed(context, '/bmi-result', arguments: bmi);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
)
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
        fillColor: Colors.white,
        hintText: hint,
          hintStyle: TextStyle(
      color: Color(0xFFC9C9C9),
    ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String hint,required TextStyle hintStyle, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
         hintText: hint,
      hintStyle: hintStyle,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildHeightInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                 hintStyle: TextStyle(
      color: Color(0xFFC9C9C9),
    ),
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
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(value: 'cm', child: Text('cm')),
                DropdownMenuItem(value: 'inch', child: Text('inch')),
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
        color: Colors.white,
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
                  hintStyle: TextStyle(
      color: Color(0xFFC9C9C9),
    ),
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
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(value: 'kg', child: Text('kg')),
                DropdownMenuItem(value: 'lbs', child: Text('lbs')),
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

  double? _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both height and weight')),
      );
      return null;
    }

    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;

    if (height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid height and weight')),
      );
      return null;
    }

    if (_selectedHeightUnit == 'inch') {
      height = height * 0.0254;
    } else {
      height = height / 100;
    }

    if (weightUnit == 'lbs') {
      weight = weight * 0.453592;
    }

    return weight / (height * height);
  }
}
