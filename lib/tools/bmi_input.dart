import 'package:flutter/material.dart';
import 'bmi_result_screen.dart';
import 'package:test_app/plan/plan_screen.dart'; 
import 'package:test_app/chat/chat_screen.dart'; 
import 'package:test_app/gamification/gamification_screen.dart'; 
import 'package:test_app/plan/fitness_wellness.dart'; 
import 'package:test_app/utils/custom_bottom_nav.dart'; 

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

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
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 18, 
            fontWeight: FontWeight.w600,
          ),
        ),
          bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1.0),
    child: Container(
      color: Colors.grey.shade300,
      height: 1.0,
    ),
  ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: 26,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter Your Information",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF222326),
                            fontSize: 16 ,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdownField(
                          hint: "Gender",
                            hintStyle: const TextStyle(color: Color(0xFFC9C9C9),fontSize: 14),

                          value: selectedGender,
                          items: const ['Female', 'Male', 'Other'],
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          _ageController, 
                          "Age ", 
                          TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 2 || age > 120) {
                              return 'Enter valid age (2-120)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildWeightInputField(),
                        const SizedBox(height: 20),
                        _buildHeightInputField(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildCalculateButton(context),
                  const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
          
          switch (index) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlanScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWelcomeScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => GamificationScreen()));
              break;
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessWellnessScreen()));
              break;
          }
        },
      ),
    );
  }

  Widget _buildCalculateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final bmi = _calculateBMI();
            if (bmi != null) {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BMIResultScreen(
      bmi: 20,
    ),
  ),
);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        
        ),
        child: const Text(
          "Calculate ",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String hint, 
    TextInputType keyboardType, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFC9C9C9),fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: hintStyle),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        isDense: true,
        filled: true,
        
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          style: const TextStyle(fontSize: 16),
        ),
      )).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $hint' : null,
    );
  }

  Widget _buildHeightInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDE5F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Enter valid height';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: ' Height',
                          hintStyle: TextStyle(color: Color(0xFFC9C9C9),fontSize: 14),

                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
  dropdownColor: Colors.white,
  style: const TextStyle(fontSize: 14, color: Colors.black),
  borderRadius: BorderRadius.circular(12),
   isExpanded: false, // set true if needed
      menuMaxHeight: 200, 
  items: const [
    DropdownMenuItem(value: 'cm', child: Text('cm')),
    DropdownMenuItem(value: 'inch', child: Text('inch')),
  ],
onChanged: (val) => setState(() => _selectedHeightUnit = val!),

)

              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildWeightInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDE5F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Enter valid weight';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Weight',
                          hintStyle: const TextStyle(color: Color(0xFFC9C9C9),fontSize: 14),

                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ),
              Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
       Container(
  height: 48,
  padding: const EdgeInsets.symmetric(horizontal: 12),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: weightUnit,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      borderRadius: BorderRadius.circular(12),
      // Force menu to appear below
      isExpanded: false, // set true if needed
      menuMaxHeight: 200, // optional
      items: const [
        DropdownMenuItem(value: 'kg', child: Text('kg')),
        DropdownMenuItem(value: 'lbs', child: Text('lbs')),
      ],
      onChanged: (val) => setState(() => weightUnit = val!),
    ),
  ),
)

            ],
          ),
        ),
      ],
    );
  }

  double? _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) return null;

    double heightInMeters;
    if (_selectedHeightUnit == 'inch') {
      heightInMeters = height * 0.0254; // inches to meters
    } else {
      heightInMeters = height / 100; // cm to meters
    }

    double weightInKg;
    if (weightUnit == 'lbs') {
      weightInKg = weight * 0.453592; // lbs to kg
    } else {
      weightInKg = weight;
    }

    return weightInKg / (heightInMeters * heightInMeters);
  }
}