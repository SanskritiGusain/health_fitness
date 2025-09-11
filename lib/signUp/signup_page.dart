// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:test_app/auth/google_auth.dart';
// import 'package:test_app/pages/home_page.dart';
// import 'package:test_app/signUp/signup_email.dart';
// import 'package:test_app/login/login_page.dart';

// class SignupSelectionPage extends StatefulWidget {
//   SignupSelectionPage({super.key});

//   @override
//   State<SignupSelectionPage> createState() => _SignupSelectionPageState();
// }

// class _SignupSelectionPageState extends State<SignupSelectionPage> {
//   final GoogleAuth _googleAuth = GoogleAuth();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FBFB),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//                 Center(
//                   child: Image.asset(
//                     'assets/images/Profile_Icon.png',
//                     height: 123.31,
//                     width: 168.25,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 const Text(
//                   "One Step Closer to a Fitter You",
//                   style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   "Choose your preferred sign-up method",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF7F7F7F),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),
//                 _buildSignUpButton(
//                   icon: Icons.email_outlined,
//                   label: "Sign up with Email",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SignupEmail(),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 14),
//                 const SizedBox(height: 32),
//                 Row(
//                   children: const [
//                     Expanded(child: Divider(thickness: 1)),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         "or continue with",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                     Expanded(child: Divider(thickness: 1)),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//                 _buildSignUpButton(
//                   icon: FontAwesomeIcons.google,
//                   label: "Continue with Google",
//                onTap: () async {
//                     print("Google button tapped");
//                     try {
//                       await _googleAuth.signInAndNotify(context);
//                     } catch (e) {
//                       print("Google Sign-In Error: $e");
//                     }
//                   },

//                 ),
//                 const SizedBox(height: 16),
//                 _buildSignUpButton(
//                   icon: FontAwesomeIcons.apple,
//                   label: "Continue with Apple",
//                   onTap: () {},
//                 ),
//                 const SizedBox(height: 25),
//                 Text.rich(
//                   TextSpan(
//                     text: "By continuing, you agree to\n",
//                     style: const TextStyle(fontSize: 12, color: Colors.black54),
//                     children: [
//                       TextSpan(
//                         text: "Terms of Use",
//                         style: const TextStyle(
//                           decoration: TextDecoration.underline,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const TextSpan(text: " and "),
//                       TextSpan(
//                         text: "Privacy Policy.",
//                         style: const TextStyle(
//                           decoration: TextDecoration.underline,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account?",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     const SizedBox(width: 4),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginSelectionPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Log in",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSignUpButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.black,
//           backgroundColor: Colors.white,
//           padding: EdgeInsets.zero,
//           elevation: 0,
//           side: const BorderSide(color: Colors.black12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Icon(icon, size: 20, color: Colors.black),
//               const SizedBox(width: 12),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/auth/google_auth.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/signUp/signup_email.dart';
import 'package:test_app/login/login_page.dart';

class SignupSelectionPage extends StatefulWidget {
  const SignupSelectionPage({super.key});

  @override
  State<SignupSelectionPage> createState() => _SignupSelectionPageState();
}

class _SignupSelectionPageState extends State<SignupSelectionPage> {
  final GoogleAuth _googleAuth = GoogleAuth();

  final List<String> images = [
    'assets/images/Frame 921(1).png',
    'assets/images/Frame 921(2).png',
    'assets/images/Frame 921(3).png',
  ];

  int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startImageLoop();
  }

  void _startImageLoop() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int nextPage = (_currentIndex + 1) % images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.38,
                width: screenWidth,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(images[index], fit: BoxFit.cover);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _dot(_currentIndex == index),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Reset Your Routine. Reclaim Your Body.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: screenWidth * 0.045,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0C0C0C),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.045),
                    // Email Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupEmail(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: screenWidth * 0.06,
                                color: Colors.black,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                "Sign up in with Email",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or continue with",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Google Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          print("Google button tapped");
                          try {
                            await _googleAuth.signInAndNotify(context);
                          } catch (e) {
                            print("Google Sign-In Error: $e");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/google_logo.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Apple Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.apple,
                                size: screenWidth * 0.06,
                                color: Colors.black,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                "Continue with Apple",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to\n",
                        style: TextStyle(
                          fontSize: screenWidth * 0.025,
                          color: Colors.black54,
                        ),
                        children: const [
                          TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy.",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),
               GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginSelectionPage(),
      ),
    );
  },
  child: RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: screenWidth * 0.035,
        color: const Color(0xFF000000),
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w500,
      ),
      children: const [
        TextSpan(text: 'Already have an account? '), // FIXED TEXT
        TextSpan(
          text: 'Log in',                              // FIXED TEXT
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  ),
),
                    SizedBox(height: screenHeight * 0.04),
                  ],
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
