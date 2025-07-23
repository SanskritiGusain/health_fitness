import 'package:flutter/material.dart';
import 'package:test_app/pages/meal_preference_page.dart';
import 'package:test_app/pages/exercise_times_input.dart';




class TransformationInputPage extends StatefulWidget {
  const TransformationInputPage({super.key});

  @override
  State<TransformationInputPage> createState() => _TransformationInputPageState();
}

class _TransformationInputPageState extends State<TransformationInputPage> {

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
                  MaterialPageRoute(builder: (context) => const ExerciseTimesInputPage()),
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
            width: 250,
            child: const Text(
              "Smart fitness, real transformation ",
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
                  "Your personalized plan evolves daily with you",
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F7F7F),
                  ),
                ),
                const SizedBox(height: 24),
                
                Center(
                  child: Image.asset(
                    'assets/images/Frame924.png',
                      height: 276,
                    width: 362,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                
   Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Left group: Line + "This App"
    Row(
      children: const [
        SizedBox(
          width: 30,
          height: 1.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF222326),
              borderRadius: BorderRadius.all(Radius.circular(104)),
            ),
          ),
        ),
        SizedBox(width: 4),
        Text(
          "This App",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'DM Sans',
            color: Color(0xFF222326),
          ),
        ),
      ],
    ),

    // Right group: Line + "Other generic Apps"
    Row(
      children: const [
        SizedBox(
          width: 30,
          height: 1.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF222326),
              borderRadius: BorderRadius.all(Radius.circular(104)),
            ),
          ),
        ),
        SizedBox(width: 4),
        Text(
          "Other generic Apps",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'DM Sans',
            color: Color(0xFF222326),
          ),
        ),
      ],
    ),
  ],
)


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
        MaterialPageRoute(builder: (context) => MealPreferencePage()),
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
