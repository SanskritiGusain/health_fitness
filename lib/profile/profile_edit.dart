import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jane Foster');
  final _emailController = TextEditingController(text: 'Jane.foster@gmail.com');
  final _phoneController = TextEditingController(text: '8798676897');
  final _dobController = TextEditingController(text: '16/04/1998');
  final _weightController = TextEditingController(text: '57');
  final _heightController = TextEditingController(text: '165');
  
  String _selectedWeightUnit = 'Kg';
  String _selectedHeightUnit = 'cm';
  bool _showPhoneError = false;
  bool _showVerificationButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture Section
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Name
              const Text(
                'Jane Foster',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              
              // Form Fields
              _buildTextFormField('Full name', _nameController),
              const SizedBox(height: 20),
              
              _buildTextFormField('Email address', _emailController),
              const SizedBox(height: 20),
              
              // Phone Number Field with Error State
              _buildPhoneField(),
              const SizedBox(height: 20),
              
              _buildTextFormField('Date of birth', _dobController),
              const SizedBox(height: 20),
              
              // Weight and Height Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _weightController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<String>(
                                value: _selectedWeightUnit,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                 contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                                ),  style: const TextStyle(
    fontSize: 12, // reduced font size
    color: Colors.black,
  ),
                                items: ['Kg', 'lbs'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                     child: Text(
        value,
        style: const TextStyle(fontSize: 12), // reduce inside dropdown too
      ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedWeightUnit = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _heightController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<String>(
                                value: _selectedHeightUnit,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                                ),
                                style: const TextStyle(
      fontSize: 12, // smaller font to avoid overflow
      color: Colors.black,
    ),
                                items: ['cm', 'ft'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                   child: Text(
          value,
          style: const TextStyle(fontSize: 12), // match smaller dropdown font
        ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedHeightUnit = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone no.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: _showPhoneError ? Colors.red : const Color(0xFFE0E0E0)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: const Text(
                '+91',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                onChanged: (value) {
                  setState(() {
                    _showPhoneError = value.length != 10;
                    _showVerificationButton = value.length == 10;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: _showPhoneError ? Colors.red : const Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: _showPhoneError ? Colors.red : Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: _showPhoneError ? Colors.red : const Color(0xFFE0E0E0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  suffixIcon: _showPhoneError ? const Icon(Icons.error, color: Colors.red) : null,
                ),
              ),
            ),
          ],
        ),
        if (_showPhoneError) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Phone number needs verification',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
              GestureDetector(
  onTap: () => _showOTPDialog(context),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color.fromARGB(255, 104, 102, 102).withOpacity(0.3),
      ),
    ),
    child: const Text(
      'Verify Now',
      style: TextStyle(
        color: Color.fromARGB(255, 132, 131, 131),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)

              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showOTPDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const OTPVerificationDialog();
      },
    );
  }
}

class OTPVerificationDialog extends StatefulWidget {
  const OTPVerificationDialog({Key? key}) : super(key: key);

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  bool isVerifying = false;

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
       insetPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20), // Removes default padding
  backgroundColor: Colors.transparent, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,

      child: Container(
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 30),
           decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16),bottom: Radius.circular(16)),
      ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 31, 31, 31),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Verify Phone no.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Enter the OTP sent to +91 8798676897',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 47,
                  child: TextFormField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code? ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle resend
                  },
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                     
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVerifying = true;
                  });
                  // Simulate verification process
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVerifying ? Colors.grey : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}