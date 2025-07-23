import 'package:flutter/material.dart';
import '../pages/effort_graph.dart';
import 'package:test_app/permission/permission_request_page.dart';

class MobileOtpVerification extends StatefulWidget {
  const MobileOtpVerification({super.key});

  @override
  State<MobileOtpVerification> createState() => _MobileOtpVerificationState();
}

class _MobileOtpVerificationState extends State<MobileOtpVerification> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
    _otpController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          _phoneController.text.trim().length == 10 &&
          _otpController.text.trim().length == 5;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            // Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
               
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign up with Phone no.',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Enter your Phone number',
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
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF7F7F7F),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Color(0xFF9EA3A9),
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: const InputDecoration(
                                      hintText: '0000000000',
                                      counterText: '',
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Verification Code',
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
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: 'Enter 6-digit code',
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
                          const SizedBox(height: 6),
                          const Text.rich(
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
                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isButtonEnabled
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PermissionRequestPage(),
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
                                'Verify & Sign up',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
                          
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
