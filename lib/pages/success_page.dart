import 'package:flutter/material.dart';
import 'package:test_app/plan/plan_screen.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  
  void _goToPlan() {
    // Navigate to the main plan/dashboard page
                     Navigator.push(context, MaterialPageRoute(builder: (context) => PlanScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: Stack(
        children: [
         // Top row with back arrow and progress bar
Padding(
  padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
  child: Row(
    children: [
      IconButton(
        icon: Image.asset(
          'assets/icons/Group(2).png',
          width: 24,
          height: 24,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      const SizedBox(width: 5),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            value: 0.40,
            minHeight: 6,
            backgroundColor: Color(0xFFECEFEE),
            color: Color(0xFF0C0C0C),
          ),
        ),
      ),
    ],
  ),
),


          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success title
                const Text(
                  'All Done',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0C0C0C),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Success illustration
                Container(
                  width: 340,
                  height: 247,
                  decoration: const BoxDecoration(
                    
                    color: Color(0xFFF8FBFB),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                 
    
  
     
     ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
    // Adjust to crop more/less
        child: Image.asset(
          'assets/images/sucess_image.jpg',
          fit: BoxFit.contain,
        ),
      ),
    ),
                      // People illustrations (positioned around the circle)
                   
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Success message
                const Text(
                  'Your Personalized Plan is ready',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222326),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Go to Plan button
          Positioned(
            bottom: 45,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _goToPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C0C0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Go to Plan',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF8FBFB),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonIcon(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}