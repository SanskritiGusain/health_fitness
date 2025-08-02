import 'package:flutter/material.dart';
import 'package:test_app/plan/plan_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../pages/home_page.dart';


class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _isEmailValid = false;
  bool _isOtpSent = false;
  bool _isOtpValid = false;
  bool _isLoading = false;
  String _lastSentEmail = '';
  
  // Timer related variables
  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool _canResend = true;
  int _resendAttempts = 0;

  // API Configuration
  static const String baseUrl = 'http://192.168.1.7:8000';
  static const String sendOtpEndpoint = '/auth/signup/email';
  static const String verifyOtpEndpoint = '/auth/verify-otp';

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
        _resetTimer();
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

  void _startResendTimer() {
    _resendAttempts++;
    setState(() {
      _canResend = false;
      _resendCountdown = 600; // 10 minutes in seconds
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
      });

      if (_resendCountdown <= 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resetTimer() {
    _resendTimer?.cancel();
    setState(() {
      _canResend = true;
      _resendCountdown = 0;
      _resendAttempts = 0;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();

      final response = await http.post(
        Uri.parse('$baseUrl$sendOtpEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          _isOtpSent = true;
          _lastSentEmail = email;
        });

        // Start timer after first OTP is sent
        _startResendTimer();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'OTP sent successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Failed to send OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$sendOtpEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _lastSentEmail,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Start timer again after resend
        _startResendTimer();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'OTP resent successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Failed to resend OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$verifyOtpEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _lastSentEmail,
          'otp': _otpController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'OTP verified'),
              backgroundColor: Colors.green,
            ),
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlanScreen(),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'OTP verification failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color(0xFFF8FBFB),
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.23,
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.05,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.23,
                    child: Image.asset(
                      'assets/images/fruit_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.03,
                  left: screenWidth * 0.03,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/Group(2).png',
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log in with Email',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0C0C0C),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Email address',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.007),
                  Theme(
  data: Theme.of(context).copyWith(
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide.none),
    ),
  ),
  child: TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintText: 'example@example.com',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  ),
),

                    if (!_isOtpSent) ...[
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: (_isEmailValid && !_isLoading) ? _sendOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isEmailValid
                                ? const Color(0xFF0C0C0C)
                                : const Color(0xFF5E605F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                    if (_isOtpSent) ...[
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        'Verification Code',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.007),
                    TextFormField(
  controller: _otpController,
  keyboardType: TextInputType.number,
  maxLength: 6,
  decoration: InputDecoration(
    counterText: '',
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    hintText: 'Enter code',
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black),
    ),
  ),
  autofillHints: const [AutofillHints.oneTimeCode],
),

                      SizedBox(height: screenHeight * 0.007),
                      GestureDetector(
                        onTap: (_canResend && !_isLoading) ? _resendOtp : null,
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't receive the code? ",
                            style: TextStyle(
                              fontSize: screenWidth * 0.028,
                              color: _isLoading ? Colors.grey : const Color(0xFF7F7F7F),
                            ),
                            children: [
                              TextSpan(
                                text: _canResend ? 'Resend' : 'Resend in ${_formatTime(_resendCountdown)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _canResend && !_isLoading 
                                      ? const Color(0xFF0C0C0C) 
                                      : const Color(0xFF0C0C0C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: (_isOtpValid && !_isLoading) ? _verifyOtp : null,
                       style: ElevatedButton.styleFrom(
  backgroundColor: _isEmailValid
      ? const Color(0xFF0C0C0C)
      : const Color.fromARGB(255, 60, 62, 61),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
).copyWith(
  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.disabled)) {
      return const Color.fromARGB(255, 65, 68, 67); // Disabled color (dark gray)
    }
    return const Color(0xFF0C0C0C); // Enabled
  }),
),

                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Verify & Log in',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
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
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: screenWidth * 0.036,
                            color: const Color(0xFF000000),
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                          children: const [
                            TextSpan(text: 'Don’t have an account? '),
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
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