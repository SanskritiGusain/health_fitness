import 'package:flutter/material.dart';
import 'package:test_app/shift/checkout_screen.dart'; 
import 'package:test_app/chat/chat_screen.dart'; 
import 'package:test_app/gamification/gamification_screen.dart'; 
import 'package:test_app/plan/fitness_wellness.dart'; 
import 'package:test_app/utils/custom_bottom_nav.dart'; 

import 'package:test_app/tools/bmi_input.dart'; 
import 'package:test_app/tools/bmr_input.dart'; 
import 'package:test_app/tools/body_fat_input.dart'; 
import 'package:test_app/tools/tdee_input.dart'; 
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        title: const Text(
          'Tools',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222326),
          ),
        ),
        centerTitle: false,
          bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1.0),
    child: Container(
      color: Colors.grey.shade300,
      height: 1.0,
    ),
  ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Calculator',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101010),
              ),
            ),
            const SizedBox(height: 12),
          Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    ToolCard(
      title: 'BMI',
      iconPath: 'assets/icons/bmi.png',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BMIScreenInput()))
    ),
    ToolCard(
      title: 'BMR',
      iconPath: 'assets/icons/bmr.png',
      onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => BMRScreenInput()))
    ),
    ToolCard(
      title: 'Body fat',
      iconPath: 'assets/icons/bodyfat.png',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>BodyFatInputPage())),
    ),
    ToolCard(
      title: 'TDEE',
      iconPath: 'assets/icons/tdee.png',
      onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => TDEEScreenInput())),
    ),
  ],
),

            const SizedBox(height: 32),
            const Text(
              'Sync',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),
           Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    ToolCard(
      title: 'Health Connect',
      iconPath: 'assets/icons/health_fitness.png',
      isVertical: true,
      iconSize: 46,
   onTap: () {
  try {
    Navigator.pushNamed(context, '/health-connect-toggle');

  } catch (e, stack) {
    print('Navigation error: $e\n$stack');
  }
},

    ),
    ToolCard(
      title: 'Wearable Devices',
      iconPath: 'assets/icons/twemoji_watch.png',
      isVertical: true,
      iconSize: 40,
      onTap: () => Navigator.pushNamed(context, '/wearables'),
    ),
  ],
),

          ],
        ),
      ),
//  bottomNavigationBar: CustomBottomNav(
//       currentIndex: 4, // 0 for Home
//       onTap: (index) {
//         if (index == 4) return; // Already on home
        
//         switch (index) {
//           case 1:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => HealthDashboardScreen()));
//             break;
//           case 2:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWelcomeScreen()));
//             break;
//           case 3:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => GamificationScreen()));
//             break;
//           case 0:
//             // Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessWellnessScreen()));
//             break;
//         }
//       },
//  ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isVertical;
  final double iconSize;
  final VoidCallback? onTap; // <-- add this

  const ToolCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.isVertical = false,
    this.iconSize = 30,
    this.onTap, // <-- and this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // <-- add this wrapper
      onTap: onTap,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 44) / 2,
        height: isVertical ? 120 : 90,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: isVertical
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: iconSize,
                      height: iconSize,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D0D0D),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        iconPath,
                        width: iconSize,
                        height: iconSize,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
// make this screen responsive for all screen 