import 'package:flutter/material.dart';
import 'package:test_app/pages/user_details.dart';

class PermissionShowPage extends StatelessWidget {
  const  PermissionShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated permissions (replace with actual logic)
    bool isLocationAllowed = false;
    bool isNotificationAllowed = true;
    bool isGoogleHealthAllowed = true;

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
                      child: Image.asset(
                        'assets/images/fruit_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // White Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "All Set! Enable More Features Anytime",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222326),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Location Permission
                      _buildPermissionRow(
                        icon: Image.asset(
                          isLocationAllowed
                              ? 'assets/icons/tabler_checkbox.png'
                              : 'assets/icons/sad_emoji.png',
                          width: 28,
                          height: 28,
                        ),
                        title: "Location - ${isLocationAllowed ? 'Allowed' : 'Denied'}",
                        subtitle: isLocationAllowed
                            ? "Awesome! We’ll use your location to make your daily tasks more relevant and effective."
                            : "Enable Location for Smarter Tracking",
                      ),
                      const SizedBox(height: 26),

                      // Notification Permission
                      _buildPermissionRow(
                        icon: Image.asset(
                          isNotificationAllowed
                              ? 'assets/icons/tabler_checkbox.png'
                              : 'assets/icons/sad_emoji.png',
                          width: 28,
                          height: 28,
                        ),
                        title: "Notifications - ${isNotificationAllowed ? 'Allowed' : 'Denied'}",
                        subtitle: isNotificationAllowed
                            ? "Great choice! Stay in sync with your daily tasks and wellness goals."
                            : "Don’t Miss Your Daily Boost",
                      ),
                      const SizedBox(height: 26),

                      // Google Health Permission
                      _buildPermissionRow(
                        icon: Image.asset(
                          isGoogleHealthAllowed
                              ? 'assets/icons/tabler_checkbox.png'
                              : 'assets/icons/sad_emoji.png',
                          width: 28,
                          height: 28,
                        ),
                        title: "Google Health - ${isGoogleHealthAllowed ? 'Allowed' : 'Denied'}",
                        subtitle: isGoogleHealthAllowed
                            ? "Health Data Synced Successfully"
                            : "Google Health access is required to sync your fitness data.",
                      ),
                      const SizedBox(height: 25),

                      const Spacer(),

                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const  UserDetailsPage()),
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
                            "Next",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
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
                  fontSize: 12,
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
