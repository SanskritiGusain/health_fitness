import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/bmi_screen.dart';
import 'next_screen.dart';
import '../signUp/signup_page.dart';

class GifSplashPage extends StatefulWidget {
  const GifSplashPage({super.key});

  @override
  State<GifSplashPage> createState() => _GifSplashPageState();
}

class _GifSplashPageState extends State<GifSplashPage>
    with SingleTickerProviderStateMixin {
  bool hasNavigated = false;
@override
void initState() {
  super.initState();
  // 9-second splash
  Future.delayed(const Duration(seconds: 9), _navigateToNext);
}

 void _navigateToNext() {
  if (!hasNavigated) {
    hasNavigated = true;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const BMIScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    // 🔸 mobile_apple.gif cropped from bottom
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.60, // Adjust to crop more/less
                        child: Image.asset(
                          'assets/images/mobile_apple.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // 🔹 text.gif cropped from bottom
                    ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.75,

                        widthFactor: 0.75, // Adjust to crop more/lessr
                        child: Image.asset(
                          'assets/images/text2.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Skip button
            
          ],
        ),
      ),
    );
  }
}
