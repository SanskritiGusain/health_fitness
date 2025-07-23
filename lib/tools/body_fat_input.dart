import 'package:flutter/material.dart';

class BodyFatInputPage extends StatefulWidget {
  const BodyFatInputPage({super.key});

  @override
  State<BodyFatInputPage> createState() => _BodyFatInputPageState();
}

class _BodyFatInputPageState extends State<BodyFatInputPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController armsController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController thighController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();

  // Focus nodes for synchronized focus states
  final FocusNode weightFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode neckFocusNode = FocusNode();
  final FocusNode chestFocusNode = FocusNode();
  final FocusNode armsFocusNode = FocusNode();
  final FocusNode waistFocusNode = FocusNode();
  final FocusNode thighFocusNode = FocusNode();
  final FocusNode hipsFocusNode = FocusNode();

  String weightUnit = 'kg';
  String heightUnit = 'cm';
  String neckUnit = 'cm';
  String chestUnit = 'cm';
  String armsUnit = 'cm';
  String waistUnit = 'cm';
  String thighUnit = 'cm';
  String hipsUnit = 'cm';
  String? selectedGender;

  final List<String> lengthUnits = ['cm', 'in'];
  final List<String> weightUnits = ['kg', 'lbs'];

  @override
  void dispose() {
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    neckFocusNode.dispose();
    chestFocusNode.dispose();
    armsFocusNode.dispose();
    waistFocusNode.dispose();
    thighFocusNode.dispose();
    hipsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        title: const Text(
          'Body fat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF222326),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 26),
              _buildDropdownField(
                hint: "Gender",
                hintStyle: const TextStyle(
                  color: Color(0xFFC9C9C9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                value: selectedGender,
                items: const ['Male', 'Female'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (selectedGender != null) ..._buildGenderSpecificFields(),
              const SizedBox(height: 32),
              ElevatedButton(
             onPressed: () {
  if (_formKey.currentState!.validate()) {
    final fat = _calculateBodyFatPercentage();
    if (fat != null) {
      Navigator.pushNamed(
        context,
        '/bodyfat-result',
        arguments: fat,
      );
    }
  }
},

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGenderSpecificFields() {
    List<Widget> fields = [];

    fields.addAll([
      const SizedBox(height: 16),
      buildValidatedTextField(placeholder: 'Age', controller: ageController),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Weight',
        controller: weightController,
        selectedUnit: weightUnit,
        unitOptions: weightUnits,
        focusNode: weightFocusNode,
        onUnitChanged: (val) => setState(() => weightUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Height',
        controller: heightController,
        selectedUnit: heightUnit,
        unitOptions: lengthUnits,
        focusNode: heightFocusNode,
        onUnitChanged: (val) => setState(() => heightUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Neck',
        controller: neckController,
        selectedUnit: neckUnit,
        unitOptions: lengthUnits,
        focusNode: neckFocusNode,
        onUnitChanged: (val) => setState(() => neckUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Chest',
        controller: chestController,
        selectedUnit: chestUnit,
        unitOptions: lengthUnits,
        focusNode: chestFocusNode,
        onUnitChanged: (val) => setState(() => chestUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Arms',
        controller: armsController,
        selectedUnit: armsUnit,
        unitOptions: lengthUnits,
        focusNode: armsFocusNode,
        onUnitChanged: (val) => setState(() => armsUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Waist',
        controller: waistController,
        selectedUnit: waistUnit,
        unitOptions: lengthUnits,
        focusNode: waistFocusNode,
        onUnitChanged: (val) => setState(() => waistUnit = val!),
      ),
      const SizedBox(height: 16),
      buildUnitTextField(
        placeholder: 'Thigh',
        controller: thighController,
        selectedUnit: thighUnit,
        unitOptions: lengthUnits,
        focusNode: thighFocusNode,
        onUnitChanged: (val) => setState(() => thighUnit = val!),
      ),
      const SizedBox(height: 16),
    ]);

    if (selectedGender == 'Female') {
      fields.add(
        buildUnitTextField(
          placeholder: 'Hips',
          controller: hipsController,
          selectedUnit: hipsUnit,
          unitOptions: lengthUnits,
          focusNode: hipsFocusNode,
          onUnitChanged: (val) => setState(() => hipsUnit = val!),
        ),
      );
    }

    return fields;
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        hintStyle: hintStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Required' : null,
    );
  }

  Widget buildValidatedTextField({
    required String placeholder,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Color(0xFFC9C9C9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF222326),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildUnitTextField({
    required String placeholder,
    required TextEditingController controller,
    required String selectedUnit,
    required List<String> unitOptions,
    required FocusNode focusNode,
    required Function(String?) onUnitChanged,
  }) {
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final bool isFocused = focusNode.hasFocus;
          final Color borderColor = isFocused ? Colors.black : const Color(0xFFD1D5DB);
          
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    onTap: () {
                      focusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: const TextStyle(
                        color: Color(0xFFC9C9C9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF222326),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Separator line
                Container(
                  width: 1,
                  height: 30,
                  color: const Color(0xFFD1D5DB),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      focusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedUnit,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          items: unitOptions
                              .map((unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            focusNode.requestFocus();
                            onUnitChanged(val);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  double? _calculateBodyFatPercentage() {
  try {
    final double height = double.parse(heightController.text);
    final double neck = double.parse(neckController.text);
    final double waist = double.parse(waistController.text);
    final double hips = selectedGender == 'Female' ? double.parse(hipsController.text) : 0;
    final double weight = double.parse(weightController.text);

    double bodyFat;

    if (selectedGender == 'Male') {
      // U.S. Navy formula for males
      bodyFat = 495 /
              (1.0324 - 0.19077 * (waist - neck) / height + 0.15456 * (height / height)) -
          450;
    } else {
      // U.S. Navy formula for females
      bodyFat = 495 /
              (1.29579 - 0.35004 * (waist + hips - neck) / height + 0.22100 * (height / height)) -
          450;
    }

    return bodyFat;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid input values')),
    );
    return null;
  }
}

}