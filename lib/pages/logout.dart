import 'package:flutter/material.dart';
import 'package:test_app/login/login_page.dart';
import '../auth/google_auth.dart'; // adjust import as per your project
 // import your login page

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final googleAuth = GoogleAuth();

    return ElevatedButton(
      onPressed: () async {
        await googleAuth.signOut();

        // Navigate to LoginPage after logout
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginSelectionPage()),
            (route) => false, // remove all previous routes
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0C0C0C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
