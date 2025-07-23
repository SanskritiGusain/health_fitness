import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/login/login_email.dart'; // Adjust the path
import 'package:test_app/login/login_mobile.dart';

class LoginSelectionPage extends StatelessWidget {
  const LoginSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Top illustration
              Center(
                child: Image.asset(
                  'assets/images/Profile_Icon.png', // use your illustration image
                  height: 123.31,
                  width:168.25,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                "Choose your preferred sign-in method",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7F7F7F),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Email button
              _buildSignUpButton(
                icon: Icons.email_outlined,
                label: "Sign up with Email",
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginEmail()),
  );
},
              ),

              const SizedBox(height: 14),

              // Phone button
              _buildSignUpButton(
                icon: Icons.phone_android_outlined,
                label: "Sign up with Phone no.",
                          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginMobile()),
  );
},
              ),

              const SizedBox(height: 32),

              // Divider
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

              const SizedBox(height: 32),

              // Google
              _buildSignUpButton(
                icon: FontAwesomeIcons.google,
                label: "Continue with Google",
                onTap: () {},
              ),

              const SizedBox(height: 16),

              // Apple
              _buildSignUpButton(
                icon: FontAwesomeIcons.apple,
                label: "Continue with Apple",
                onTap: () {},
              ),
const SizedBox(height: 25),
              

              // Terms and policy
              Text.rich(
                TextSpan(
                  text: "By continuing, you agree to\n",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Terms of Use",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy.",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // Navigate to login
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
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
        padding: EdgeInsets.zero, // remove default padding
        elevation: 0,
        side: const BorderSide(color: Colors.black12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25), // left padding here
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, size: 20, color: Colors.black),
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

}
