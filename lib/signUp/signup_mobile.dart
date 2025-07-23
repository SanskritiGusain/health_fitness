import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mobile_otp_verification.dart'; // Replace with your actual import

class SignupMobile extends StatefulWidget {
  const SignupMobile({super.key});

  @override
  State<SignupMobile> createState() => _SignupMobileState();
}

class _SignupMobileState extends State<SignupMobile> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image Section
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFF8FBFB)),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 31,
                    child: SizedBox(
                      width: 248,
                      height: 120.49,
                      child: Image.asset(
                        'assets/images/fruit_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                 Positioned(
  top: 30,
  right: 10,
  child: Container(
    height: 100,
    width: 100,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFFDAF3F1),
    ),
    child: OverflowBox(
      maxHeight: 120, // larger than 100 to overflow
      maxWidth: 120,
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/images/man_avtar.png',
        height: 120,
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                  Positioned(
                    top: 20,
                    left: 12,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/Group(2).png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                  
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sign up with Phone no.',
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0C0C0C),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Phone Number Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter your phone number',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFF5F5F5), width: 1.5),
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: const Text(
                                      '+91',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF7F7F7F),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 28,
                                    color: const Color(0xFF9EA3A9),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      focusNode: _phoneFocusNode,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                      maxLength: 10,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0C0C0C),
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: '0000000000',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFC9C9C9),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                        counterText: '',
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _isButtonEnabled = value.length == 10;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // SMS Info
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "we’ll send a verification code via SMS",
                              style: TextStyle(fontSize: 10, color: Color(0xFF7F7F7F)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Send OTP Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MobileOtpVerification(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonEnabled
                                  ? const Color(0xFF0C0C0C)
                                  : const Color(0xFF7F8180),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Spacer(),

                        // Login Prompt
                        GestureDetector(
                          onTap: () {
                            // Navigate to login screen here
                          },
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(text: 'Already have an account? '),
                                  TextSpan(
                                    text: 'Log in',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
