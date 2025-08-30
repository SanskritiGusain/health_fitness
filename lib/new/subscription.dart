import 'package:flutter/material.dart';
import 'package:test_app/new/premium_active.dart';
import 'package:test_app/plan/checkout_page.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlanIndex = 1; // Default to "Best Value" plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context),
              _buildContentSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final heroHeight = screenHeight * (isTablet ? 0.4 : 0.45);

    return Container(
      height: heroHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Curved grey background + girl image together
          Container(
            height: heroHeight + 50,
            width: double.infinity,
            child: ClipPath(
              clipper: Customshape(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Grey background
                  Container(color: const Color.fromARGB(255, 158, 158, 158)),

                  // Girl image inside the curve - responsive sizing
                  Container(
                    height: heroHeight * 0.9,
                    width: screenWidth * (isTablet ? 0.35 : 0.65),
                    child: Image.asset(
                      'assets/images/girl.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back button - responsive positioning
          Positioned(
            top: screenHeight * 0.015,
            left: screenWidth * 0.02,
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

          // Left image - responsive positioning and sizing
          Positioned(
            bottom: heroHeight * 0.04,
            left: screenWidth * 0.001,
            child: Container(
              width: screenWidth * (isTablet ? 0.15 : 0.3),
              height: screenWidth * (isTablet ? 0.15 : 0.28),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/fruit_plate.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Right image - responsive positioning and sizing
          Positioned(
            right: screenWidth * 0.02,
            bottom: heroHeight * 0.10,
            child: Container(
              width: screenWidth * (isTablet ? 0.15 : 0.28),
              height: screenWidth * (isTablet ? 0.18 : 0.35),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = screenWidth * (isTablet ? 0.08 : 0.04);
    bool hasPlan = true; // if user has a plan
    bool isExpired = false;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offer tag
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  isExpired
                      ? const Color.fromARGB(255, 180, 24, 13)
                      : Color(0xFF3C8F7C), // Grey for expired
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isExpired) ...[
                  Icon(
                    Icons.access_time,
                    size: isTablet ? 28 : 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  hasPlan
                      ? (isExpired ? "Plan Expire" : "LIMITED TIME OFFER")
                      : "Plan Expire", // optional
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.04),

          // Title - responsive text size
          Text(
            "Jane, here's 50% off Premium",
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenWidth * 0.06),

          // Section title - responsive text size
          Text(
            "Unlock Benefits",
            style: TextStyle(
              fontSize: isTablet ? 26 : 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3C8F7C),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),

          // Benefits
          _buildBenefit(
            "Unlimited Chat with AI Coach",
            "Get instant advice, motivation, and expert guidance 24/7.",
            isTablet,
          ),
          _buildBenefit(
            "Personalized Plans – Modified by AI Coach",
            "Get instant advice, motivation, and expert guidance 24/7.",
            isTablet,
          ),
          _buildBenefit(
            "Diet According to Your Geographical Location",
            "Get instant advice, motivation, and expert guidance 24/7.",
            isTablet,
          ),
          _buildBenefit(
            "Plans Tailored to Medical Conditions & Needs",
            "Get instant advice, motivation, and expert guidance 24/7.",
            isTablet,
          ),

          SizedBox(height: screenWidth * 0.08),

          // Pricing cards - responsive layout
          _buildPricingSection(context),

          SizedBox(height: screenWidth * 0.07),

          // Continue button - responsive sizing
          SizedBox(
            width: double.infinity,
            height: isTablet ? 60 : 50,
            child: ElevatedButton(
              onPressed: () {
              
                  if (hasPlan == true) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder:
                  //         (context) => CheckoutScreen(
                  //           title: "Belly Fit Plan",
                  //           badge: "Popular",
                  //           imageAsset: "assets/images/plan.png",
                  //           description:
                  //               "Lose weight effectively with expert guidance.",
                  //           weightLoss: "Up to 5kg in a month",
                  //           originalPrice: "₹3,500", // optional
                  //           subText: "Best for beginners",
                  //           subTextColor: Colors.green,
                  //           showCoach: true, // optional
                  //           showAI: true, // optional
                  //           showDiscount: true, // optional
                  //           hasCouponApplied: false, // optional
                  //         ),
                  //   ),
                  // ); 
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PremiumActiveScreen()
                    ),
                  );

                  } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PremiumActiveScreen()
                    ),
                  );
             
                };
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.07),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (isTablet) {
      // For tablets, show cards side by side with more spacing
      return Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: _buildPlanCard(
                0,
                "₹500",
                "Per week",
                "Billed weekly\n₹2,000 per month",
                isTablet,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              child: _buildPlanCard(
                1,
                "₹1,499",
                "per month",
                "Billed monthly\n₹375.00 per week",
                isTablet,
                bestValue: true,
              ),
            ),
          ),
        ],
      );
    } else {
      // For mobile, maintain original layout
      return Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              child: _buildPlanCard(
                0,
                "₹500",
                "Per week",
                "Billed weekly\n₹2,000 per month",
                isTablet,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 6),
              child: _buildPlanCard(
                1,
                "₹1,499",
                "per month",
                "Billed monthly\n₹375.00 per week",
                isTablet,
                bestValue: true,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildBenefit(String title, String subtitle, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: isTablet ? 28 : 24, color: Color(0xFF3C8F7C)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    int index,
    String price,
    String period,
    String desc,
    bool isTablet, {
    bool bestValue = false,
  }) {
    bool isSelected = selectedPlanIndex == index;
    final cardHeight = isTablet ? 180.0 : 150.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanIndex = index;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main card
          Container(
            width: double.infinity,
            height: cardHeight,
            padding: EdgeInsets.all(isTablet ? 18 : 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Color(0xFF3C8F7C) : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.2,
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (bestValue) SizedBox(height: isTablet ? 20 : 16),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 22,
                    fontWeight: FontWeight.w600,
                    color: bestValue ? Color(0xFF3C8F7C) : Colors.black,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 2),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Color.fromARGB(255, 85, 83, 83),
                  ),
                ),
              ],
            ),
          ),

          // Best Value banner
          if (bestValue)
            Positioned(
              top: isTablet ? 10 : 8,
              left: 1.6,
              child: CustomPaint(
                painter: BestValueBannerPainter(),
                child: Container(
                  padding: EdgeInsets.only(
                    left: isTablet ? 16 : 12,
                    right: isTablet ? 24 : 20,
                    top: isTablet ? 6 : 4,
                    bottom: isTablet ? 6 : 4,
                  ),
                  child: Text(
                    "Best Value",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
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

class BestValueBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Top edge (straight)
    path.lineTo(size.width, 0);

    // Right-center inward point
    path.lineTo(size.width - 12, size.height / 2);

    // Bottom-right corner
    path.lineTo(size.width, size.height);

    // Bottom edge (straight)
    path.lineTo(0, size.height);

    // Close path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();

    // Start from top-left
    path.lineTo(0, height - (height * 0.2));

    // Create the gentle dip curve in the middle - responsive
    path.quadraticBezierTo(
      width * 0.5, // Control point X at center
      height - (height * 0.02), // Control point Y - shallow dip
      width, // End point X
      height - (height * 0.35), // End point Y
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
