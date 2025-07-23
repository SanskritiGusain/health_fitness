import 'package:flutter/material.dart';
import 'gif_splash_page.dart';

import '../pages/desired_weight.dart';


class EffortGraph extends StatefulWidget {
  const EffortGraph({super.key});

  @override
  State<EffortGraph> createState() => _EffortGraphState();
}

class _EffortGraphState extends State<EffortGraph> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: Stack(
        children: [
          // Back arrow
          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              icon: Image.asset(
                'assets/icons/Group(2).png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DesiredWeight()),
                );
              },
            ),
          ),

          // Progress bar
          Positioned(
            top: 115,
            left: 20,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.60,
                minHeight: 6,
                backgroundColor: const Color(0xFFECEFEE),
                color: const Color(0xFF0C0C0C),
              ),
            ),
          ),

          // Title
          Positioned(
            top: 184,
            left: 20,
            width: 359,
            child: const Text(
              "Your Effort, Amplified Every\nDay ",
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 20,
                height: 1.2,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Subheading + Graph + Labels
          Positioned(
            top: 260,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Small wins add up fast with personalized plans,\nsmart tracking, and daily motivation – making\nyour weight loss journey simple, structured, and\nsustainable.",
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F7F7F),
                  ),
                ),
                const SizedBox(height: 24),
                
                Center(
                  child: Image.asset(
                    'assets/images/Frame 924(1).png',
                      height: 276,
                    width: 362,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                
  


              ],
            ),
          ),

          // Next button
          Positioned(
            bottom: 45,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed:  (){   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GifSplashPage()),
      );},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C0C0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
