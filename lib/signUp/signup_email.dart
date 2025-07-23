import 'package:flutter/material.dart';
import 'package:test_app/permission/permission_request_page.dart';
import '../pages/effort_graph.dart';

class SignupEmail extends StatefulWidget {
  const SignupEmail({super.key});

  @override
  State<SignupEmail> createState() => _SignupEmailState();
}

class _SignupEmailState extends State<SignupEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _isEmailValid = false;
  bool _isOtpSent = false;
  bool _isOtpValid = false;
  String _lastSentEmail = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _otpController.addListener(_validateOtp);
  }

  void _onEmailChanged() {
    final emailText = _emailController.text.trim();
    final isValid = emailRegex.hasMatch(emailText);

    if (_isOtpSent && emailText != _lastSentEmail) {
      setState(() {
        _isOtpSent = false;
        _otpController.clear();
      });
    }

    setState(() {
      _isEmailValid = isValid;
    });
  }

  void _validateOtp() {
    setState(() {
      _isOtpValid = _otpController.text.trim().length == 6;
    });
  }

  void _sendOtp() {
    setState(() {
      _isOtpSent = true;
      _lastSentEmail = _emailController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Sent")),
    );

    // TODO: Call API to send OTP to _lastSentEmail
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Resent")),
    );

    // TODO: Call API to resend OTP
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // important
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: Image.asset(
                        'assets/images/fruit_bg.png',
                        fit: BoxFit.cover,
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
                          MaterialPageRoute(
                            builder: (context) => const EffortGraph(),
                          ),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign up with Email',
                        style: TextStyle(
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
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: 'example@example.com',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC9C9C9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),

                      if (!_isOtpSent) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isEmailValid ? _sendOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEmailValid
                                  ? const Color(0xFF0C0C0C)
                                  : const Color(0xFF5E605F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (_isOtpSent) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _otpController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            hintText: 'Enter 6-digit code',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC9C9C9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.black),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16),
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _resendOtp,
                          child: const Text.rich(
                            TextSpan(
                              text: "Didn't receive the code? ",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF7F7F7F),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Resend',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0C0C0C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: (){
                                                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PermissionRequestPage(),
     
    ),

);
                            },
                            // onPressed: _isOtpValid
                            //     ? () {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           const SnackBar(
                            //               content: Text("OTP Verified")),
                            //         );
                            //       }
                            //     : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isOtpValid
                                  ? const Color(0xFF0C0C0C)
                                  : const Color(0xFF7F8180),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Verify & Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],

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
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log in',
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
