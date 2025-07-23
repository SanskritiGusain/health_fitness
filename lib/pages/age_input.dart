import 'package:flutter/material.dart';
import 'gender_input.dart';
import 'user_details.dart'; 
import 'package:intl/intl.dart';
import '../utils/custom_date_picker.dart';

class AgeInputPage extends StatefulWidget {
  const AgeInputPage({super.key});

  @override
  State<AgeInputPage> createState() => _AgeInputPageState();
}

class _AgeInputPageState extends State<AgeInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  bool _isButtonEnabled = false; // 🔹 Track button state

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_updateButtonState); // 🔹 Listen for changes
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _ageController.text.trim().isNotEmpty;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GenderInputPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFFF8FBFB),
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
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => const NameInputPage()),
  // );
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
                value: 0.25,
                minHeight: 6,
                backgroundColor: Color(0xFFECEFEE),
                color: Color(0xFF0C0C0C),
              ),
            ),
          ),

          // Question
          Positioned(
            top: 152,
            left: 20,
            child: const Text(
              "What is your date of birth?",
              style: TextStyle(
                fontFamily: 'Merriweather',
                 fontSize: 20,
                height: 2.8,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Age Input Field with Form
          Positioned(
            top: 230,
            left: 16,
            right: 16,
            child: Form(
              key: _formKey,
              child:TextFormField(
  controller: _ageController,
  readOnly: true,
  onTap: () async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => const CustomDatePicker(),
    );

    if (selectedDate != null) {
      setState(() {
        _ageController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  },
  cursorColor: const Color(0xFF222326),
  style: const TextStyle(
    fontFamily: 'DM Sans',
    fontWeight: FontWeight.w500,
     fontSize: 14,
      height: 2.0,
    color: Color(0xFF222326),
  ),
  decoration: InputDecoration(
    hintText: 'DD/MM/YYYY',
    hintStyle: const TextStyle(
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 2.0,
      color: Color(0xFFC9C9C9),
    ),
    suffixIcon: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Image.asset(
        'assets/icons/uil_calender.png',
        width: 20,
        height: 20,
      ),
    ),
    suffixIconConstraints: const BoxConstraints(
      minHeight: 20,
      minWidth: 20,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDE5F0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDE5F0), width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDE5F0), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDE5F0), width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }

    try {
      DateFormat('dd/MM/yyyy').parseStrict(value.trim());
    } catch (_) {
      return 'Enter a valid date';
    }

    return null;
  },
),


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
          fontSize: 15,
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
