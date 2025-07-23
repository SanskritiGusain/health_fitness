import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/bmi_screen.dart';
import 'next_screen.dart';


class BmiGifScreen extends StatefulWidget {
  const BmiGifScreen({super.key});

  @override
  State<BmiGifScreen> createState() => _BmiGifScreenState();
}

class _BmiGifScreenState extends State<BmiGifScreen>
    with SingleTickerProviderStateMixin {
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 9000), _navigateToNext);
  }

  void _navigateToNext() {
    if (!hasNavigated) {
      hasNavigated = true;
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const BMIScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final springAnimation = CurvedAnimation(
              parent: animation,
              curve: const SpringCurve(stiffness: 711.1, damping: 40),
            );
            return FadeTransition(
              opacity: springAnimation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child:Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    const SizedBox(height: 30),
     // 🔸 mobile_apple.gif cropped from bottom
     ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
    // Adjust to crop more/less
        child: Image.asset(
          'assets/images/bmi_weight.gif',
          fit: BoxFit.contain,
        ),
      ),
    ),

  


   
   
  ],
),


              ),
            ),

            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _navigateToNext,
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
