import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/signUp/signup_email.dart';
import 'package:test_app/login/login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/images/Frame 921(1).png',
    'assets/images/Frame 921(2).png',
    'assets/images/Frame 921(3).png',
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startImageLoop();
  }

  void _startImageLoop() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(
                        images[_currentIndex],
                        key: ValueKey<String>(images[_currentIndex]),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                 
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _dot(_currentIndex == index),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Reset Your Routine. Reclaim Your Body.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 19,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0C0C0C),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildSignUpButton(
                      icon: Icons.email_outlined,
                      label: "Sign up with Email",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupEmail()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("or continue with", style: TextStyle(color: Colors.black54)),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSignUpButton(
                      icon: FontAwesomeIcons.google,
                      label: "Continue with Google",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildSignUpButton(
                      icon: FontAwesomeIcons.apple,
                      label: "Continue with Apple",
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to\n",
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                        children: [
                          const TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(text: " and "),
                          const TextSpan(
                            text: "Privacy Policy.",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginSelectionPage()),
                        );
                      },
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
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          elevation: 0,
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 25, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool isActive) {
    return Container(
      width: isActive ? 36 : 8,
      height: isActive ? 7 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0C0C0C) : const Color(0xFFD9D9D9),
        shape: isActive ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isActive ? BorderRadius.circular(6) : null,
      ),
    );
  }
}
