import 'package:flutter/material.dart';
import 'package:test_app/permission/permission_show.dart';

class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                     width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: Image.asset('assets/images/fruit_bg.png',
                       fit: BoxFit.cover,),
                      
                    ),
                  ),
                
                ],
              ),
            ),

            // Full width white container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                 // Added for symmetry
                  ),
                
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Give Us a Green Light to Guide You Right!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222326),
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildPermissionRow(
                        icon: Image.asset(
                        'assets/icons/location.png',
                        width: 24,
                        height: 24,
                      ),
                        title: "Location",
                        subtitle:
                            "Get more relevant fitness suggestions and real-time progress based on where you are.",
                      ),
                      const SizedBox(height: 26),

                      _buildPermissionRow(
                     icon: Image.asset(
                        'assets/icons/notification.png',
                        width: 24,
                        height: 24,
                      ),
                       
                        title: "Notifications",
                        subtitle:
                            "Get timely nudges for your daily tasks, meals, and workouts.",
                      ),
                      const SizedBox(height: 26),

                      _buildPermissionRow(
                         icon: Image.asset(
                        'assets/icons/healthAndFitness.png',
                        width: 24,
                        height: 24,
                      ),
                        title: "Google health",
                        subtitle:
                            "Allow syncing to reduce manual input and track your journey automatically.",
                      ),

                      const SizedBox(height: 20),
const Spacer(),
                      // Allow Permission Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const  PermissionShowPage(),
     
    ),

);

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Allow Permission",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Skip for Now Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle skip
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.black),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            "Skip for Now",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRow({
      required Widget icon,
    required String title,
    required String subtitle,
  
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         icon,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7F7F7F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
