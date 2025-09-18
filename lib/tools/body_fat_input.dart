import 'dart:math';
import 'package:flutter/material.dart';
import 'body_fat_result_screen.dart';
import 'package:test_app/utils/textflied_unit_dropdown.dart';

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

  String? selectedGender;
  String weightUnit = 'kg';
  String heightUnit = 'cm';
  String neckUnit = 'cm';
  String chestUnit = 'cm';
  String armsUnit = 'cm';
  String waistUnit = 'cm';
  String thighUnit = 'cm';
  String hipsUnit = 'cm';

  final List<String> lengthUnits = ['cm', 'in'];
  final List<String> weightUnits = ['kg', 'lbs'];

  @override
  Widget build(BuildContext context) {
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
          'Body Fat',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft, // Right-align text
                      child: const Text(
                        "Enter Your Information",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222326),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Gender Dropdown
                    _buildSimpleDropdown(
                      hint: "Gender",
                      value: selectedGender,
                      items: const ['Male', 'Female'],
                      onChanged: (val) => setState(() => selectedGender = val),
                    ),
                    const SizedBox(height: 16),

                    if (selectedGender != null) ..._buildGenderFields(),
                    const SizedBox(height: 16),
                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {
                        if (_validateFields()) {
                          final fat = _calculateBodyFatPercentage();
                          if (fat != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BodyFatResultScreen(
                                  bodyFatPercentage: fat,
                                  gender: selectedGender!,
                                ),
                              ),
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
        },
      ),
    );
  }

  List<Widget> _buildGenderFields() {
    List<Widget> fields = [];

    fields.addAll([
      _buildSimpleInput(ageController, "Age"),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: weightController,
        hintText: "Weight",
        value: weightUnit,
        items: weightUnits,
        onChanged: (val) => setState(() => weightUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: heightController,
        hintText: "Height",
        value: heightUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => heightUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: neckController,
        hintText: "Neck",
        value: neckUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => neckUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: chestController,
        hintText: "Chest",
        value: chestUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => chestUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: armsController,
        hintText: "Arms",
        value: armsUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => armsUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: waistController,
        hintText: "Waist",
        value: waistUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => waistUnit = val!),
      ),
      const SizedBox(height: 16),
      CustomInputWithDropdown(
        controller: thighController,
        hintText: "Thigh",
        value: thighUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => thighUnit = val!),
      ),
      const SizedBox(height: 16),
    ]);

    if (selectedGender == 'Female') {
      fields.add(CustomInputWithDropdown(
        controller: hipsController,
        hintText: "Hips",
        value: hipsUnit,
        items: lengthUnits,
        onChanged: (val) => setState(() => hipsUnit = val!),
      ));
    }

    return fields;
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
      height: 48,
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
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  bool _validateFields() {
    if (selectedGender == null ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        neckController.text.isEmpty ||
        waistController.text.isEmpty ||
        thighController.text.isEmpty ||
        (selectedGender == 'Female' && hipsController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return false;
    }
    return true;
  }

  double? _calculateBodyFatPercentage() {
    try {
      double height = double.parse(heightController.text);
      double neck = double.parse(neckController.text);
      double waist = double.parse(waistController.text);
      double hips = selectedGender == 'Female'
          ? double.parse(hipsController.text)
          : 0;

      if (heightUnit == 'cm') height /= 2.54;
      if (neckUnit == 'cm') neck /= 2.54;
      if (waistUnit == 'cm') waist /= 2.54;
      if (hipsUnit == 'cm') hips /= 2.54;

      double bodyFat;

      if (selectedGender == 'Male') {
        bodyFat = 86.010 * (log(waist - neck) / ln10) -
            70.041 * (log(height) / ln10) +
            36.76;
      } else {
        bodyFat = 163.205 * (log(waist + hips - neck) / ln10) -
            97.684 * (log(height) / ln10) -
            78.387;
      }

      return double.parse(bodyFat.toStringAsFixed(2));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input values')),
      );
      return null;
    }
  }
}
