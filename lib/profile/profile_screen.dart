// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/login/login_page.dart';
import 'package:test_app/new/subscription.dart';
import 'package:test_app/profile/alert_screen.dart';
import 'package:test_app/profile/profile_edit.dart';
import 'package:test_app/profile/refer_friend.dart';
import 'package:test_app/profile/setting_screen.dart';
import 'package:test_app/profile/help_screen.dart';
import 'package:test_app/new/subscription.dart';
import '../auth/google_auth.dart'; 
import 'package:test_app/utils/custom_app_bars.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Future<void> signout() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  @override
  Widget build(BuildContext context) {
  //  final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBars.backAppBar(context, "Body Metrics"),
      body: Column(
        children: [
          // Fixed Top Section with Background Image
          Container(
            height:
                MediaQuery.of(context).size.height *
                0.38, // Fixed height for top section
            child: Stack(
              children: [
                // Background image positioned behind the profile content
                Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    'assets/icons_update/background.svg',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),

                // Profile Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      const Text(
                        'Jane Foster',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats Container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Basic Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('75 Kg', 'Weight'),
                                _buildDivider(),
                                _buildStatItem('28', 'Years old'),
                                _buildDivider(),
                                _buildStatItem('165 CM', 'Height'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Bottom Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      'assets/icons_update/iconamoon_profile-fill.svg',
                      'Profile',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/famicons_card.svg',
                      'Subscription',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(),
                          ),
                        );
                        // Handle alert tap
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/mdi_clock.svg',
                      'Alert',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlertScreen(),
                          ),
                        );
                        // Handle alert tap
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/material-symbols_settings.svg',
                      'Settings',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/dosh_icon.svg',
                      'Dosha Quiz',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlertScreen(),
                          ),
                        );
                        // Handle alert tap
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/mingcute_gift-fill.svg',
                      'Refer Friend',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReferralScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/mingcute_lock-fill.svg',
                      'Privacy Policy',
                      () {
                        // Handle privacy policy tap
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/tdesign_chat-bubble-help-filled.svg',
                      'Help',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpScreen()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      'assets/icons_update/majesticons_logout.svg',
                      'Logout',
                      () {
                        // Handle logout tap
                        _showLogoutDialog(context);
                      },
                      isLast: true,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 0, color: Colors.white);
  }

  Widget _buildMenuItem(
    String iconAsset,
    String title,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 44, // You can adjust width as needed
                height: 44, // Optional: Set height to keep it square
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // Background color
                  color: const Color(0xFFE0E7ED),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),

                // Replace Image.asset with:
                child: SvgPicture.asset(
                  iconAsset,
                  width: 23,
                  height: 23,
                  color: const Color.fromARGB(255, 19, 18, 18),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 26, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
        final googleAuth = GoogleAuth();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, size: 26, color: Colors.white),
              ),
              const SizedBox(height: 16),

              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                           Navigator.pop(context); 
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
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
