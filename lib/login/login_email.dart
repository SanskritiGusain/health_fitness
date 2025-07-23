import 'package:flutter/material.dart';
import '../pages/effort_graph.dart';
import '../login/email_otp_verification.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    setState(() {
      _isButtonEnabled = emailRegex.hasMatch(_emailController.text.trim());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header section...
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 31,
                    child: SizedBox(
                      width: 248,
                      height: 120,
                      child: Image.asset('assets/images/fruit_bg.png'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EffortGraph()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                  
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Log in with Email',
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0C0C0C),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Email address',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'example@example.com',
                            hintStyle: TextStyle(
                              color: Color(0xFFC9C9C9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "we'll send a verification code to your email",
                        style: TextStyle(fontSize: 10, color: Color(0xFF7F7F7F)),
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
                                    MaterialPageRoute(builder: (context) => const EmailOtpVerification()),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isButtonEnabled ? const Color(0xFF0C0C0C) : const Color(0xFF7F8180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      Center(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF000000),
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(text: 'Don’t have an account? '),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
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
