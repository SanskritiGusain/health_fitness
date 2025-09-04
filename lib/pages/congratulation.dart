import 'package:flutter/material.dart';
import 'package:test_app/pages/logout.dart';
import 'package:test_app/plan/fitness_wellness.dart';
import 'package:test_app/shared_preferences.dart';
import 'package:test_app/web_socket/chat_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CongratulationsScreen extends StatelessWidget {
  // Hardcoded data - will be replaced with API data in future
  final Map<String, dynamic> planData = {
    'title': 'Congratulations,',
    'subtitle': 'Your Personalized Plan Is Ready',
    'sectionTitle': 'Unlock Benefits',
    'benefits': [
      'Unlimited Chat with AI Coach',
      'Personalized Plans - Modified by AI Coach',
      'Diet According to Your Geographical Location',
      'Plans Tailored to Medical Conditions & Needs',
    ],
    'trialText': 'Unlock 7 days Free Trial',
  };
  Future<void> _startTrial() async {
    String? token = await PersistentData.getAuthToken();
    if (token == null) {
      debugPrint("❌ No auth token found");
      return;
    }
    debugPrint("🟢 Auth token: $token");
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse("ws://192.168.1.30:8000/chat/ws/user?token=$token"),
      );

      // Send user details once
      final userData = await PersistentData.getAllPersistentData();
      channel.sink.add(userData.toString());

      debugPrint("✅ Trial user data sent: $userData");

      // Disconnect after sending
      await Future.delayed(const Duration(seconds: 1));
      await channel.sink.close();
    } catch (e) {
      debugPrint("❌ Trial WebSocket error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and status bar
            // _buildHeader(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero section with girl image and curved background
                    _buildHeroSection(),

                    // Content section
                    _buildContentSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             // Handle back navigation
  //           },
  //           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeroSection() {
    return Container(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Curved grey background + girl image together
          Container(
            height: 450,
            width: double.infinity,
            child: ClipPath(
              clipper: Customshape(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Grey background
                  Container(color: const Color.fromARGB(255, 158, 158, 158)),

                  // Girl image inside the curve
                  SizedBox(
                    height: 302,
                    width: 260,
                    child: Image.asset(
                      'assets/images/girl.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                onPressed: () {
                  // Handle back navigation
                  // Navigator.pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
              ),
            ),
          ),

          // Left image
          Positioned(
            top: 190,
            left: 10,
            child: Container(
              width: 124,
              height: 99,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/fruit_plate.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Right image
          Positioned(
            right: 20,
            top: 120,
            child: Container(
              width: 100,
              height: 129,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/ots_blow.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and subtitle
          Text(
            planData['title'],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            planData['subtitle'],
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 32),

          // Section title
          Text(
            planData['sectionTitle'],
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF3C8F7C),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),

          // Benefits list
          ...planData['benefits']
              .map<Widget>((benefit) => _buildBenefitItem(benefit))
              .toList(),

          SizedBox(height: 180),

          // Call to action button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ChatSocketPage(),
                //   ),
                // );
                await _startTrial();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogoutButton(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                planData['trialText'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,

            child: Icon(Icons.check, color: Color(0xFF3C8F7C), size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for curved bottom

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();

    // Start from top-left
    path.lineTo(0, height - 90);

    // Create the gentle dip curve in the middle
    path.quadraticBezierTo(
      width * 0.5, // Control point X at center
      height - 10, // Control point Y - shallow dip
      width, // End point X
      height - 160, // End point Y
    );

    // Complete the shape
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
