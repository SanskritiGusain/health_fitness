import 'package:flutter/material.dart';

import 'motivation_input.dart';
import 'medical_condition.dart';

class DropWeight extends StatelessWidget {
  const DropWeight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and progress bar
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                child: Column(
                  children: [
                    // Back Button
          Padding(
  padding: const EdgeInsets.only( bottom: 5,top: 15),
  child: Align(
    alignment: Alignment.centerLeft,
    child: IconButton(
      icon: Image.asset(
        'assets/icons/Group(2).png',
        width: 24,
        height: 24,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicalConditionPage()),
        );
      },
    ),
  ),
),

                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.55,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFECEFEE),
                          color: const Color(0xFF0C0C0C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Quote text
                          const Text(
                            '"Dropping 5-10 kg just got\neasier- with daily plans that\nadjust to you."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 20,
                              height: 1.3,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF222326),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Subtitle
                          const Text(
                            "No more planning. Just follow your\npersonalised plan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 1,
                              color: Color(0xFF7F7F7F),
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          // Circular illustration
                          Container(
                            width: 394,
                            height: 394,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC8EDEA),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/male_image.png',
                                  width: 276,
                                  height: 414,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Next Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MotivationInput()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0C0C0C),
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
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}