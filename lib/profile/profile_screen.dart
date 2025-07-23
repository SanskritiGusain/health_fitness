import 'package:flutter/material.dart';
import 'package:test_app/profile/alert_screen.dart';
import 'package:test_app/profile/profile_edit.dart';
import 'package:test_app/profile/refer_friend.dart';
import 'package:test_app/profile/setting_screen.dart';
import 'package:test_app/profile/help_screen.dart';
import 'package:test_app/profile/alert_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              'assets/icons/Group(2).png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Background image positioned behind the white card
          Positioned(
            top: 200, // Half the height from top of the profile card
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/background_pattern.jpg'), // Add your background image
                  fit: BoxFit.cover,
                  opacity: 0.1, // Make it subtle
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section - Direct on screen, no container
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
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
                            
                         
                            
                            // Blue highlight box
                           
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Menu Items - Direct on screen
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        'assets/icons/iconamoon_profile.png',
                        'Profile',
                        () {
                          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditScreen()),
    );
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/alert_icon.png',
                        'Alert',
                        () {                                  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlertScreen()),
    );
                          // Handle alert tap
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/famicons_settings-outline.png',
                        'Settings',
                        () {
                                           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/refer_icon.png',
                        'Refer Friend',
                        () {
                                                        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReferralScreen()),
    );
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/privacy_icon.png',
                        'Privacy Policy',
                        () {
                          // Handle privacy policy tap
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/ri_customer-service-2-line.png',
                        'Help',
                        () {
                          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
                        },
                      ),
                      _buildMenuItem(
                        'assets/icons/logout.png',
                        'Logout',
                        () {
                          // Handle logout tap
                          _showLogoutDialog(context);
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white,
    );
  }

  Widget _buildMenuItem(
    String iconAsset,
    String title,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return 
      
     
   Material(
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
    borderRadius: BorderRadius.circular(30), // Rounded corners
    border: Border.all(
      color: Colors.grey, // Border color
      width: 1,           // Border width
    ),
  ),
  child: Image.asset(
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 26,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      );
  
  }

void _showLogoutDialog(BuildContext context) {
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
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Perform logout
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