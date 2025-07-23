import 'package:flutter/material.dart';

// Import the detail screen
import 'package:test_app/plan/plan_detail.dart';
// Import the checkout screen
import 'package:test_app/plan/checkout_page.dart';
import 'package:test_app/plan/transformation_support_screen.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(''),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildProgressBar(true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildProgressBar(true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildProgressBar(false)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildProgressBar(false)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Best Recommend Plans for You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPlanCard(
                  context,
                  imageAsset: 'assets/images/plan1.jpg',
                  title: 'AdaptFit',
                  badge: 'Recommend',
                  badgeColor: Color(0xB2E6F7F6),
                  description: 'Fitness that adapts results',
                  weightLoss: 'Upto 5 kg fat loss/month',
                  subText: 'Free',
                  subTextColor: Color(0xFFFFCC00),
                  showCoach: false,
                  showAI: true,
                ),
                const SizedBox(height: 12),
                _buildPlanCard(
                  context,
                  imageAsset: 'assets/images/plan2.png',
                  title: 'Belly Fit',
                  badge: 'Best Seller',
                  badgeColor: Color(0xB2E6F7F6),
                  description: 'Naturally sustainable weight loss',
                  weightLoss: 'Upto 4 kg fat loss/month',
                  originalPrice: '₹2,499',
                  subText: '₹1,499',
                  subTextColor: Colors.black,
                  showCoach: true,
                  showAI: false,
                  showDiscount: true,
                ),
                const SizedBox(height: 12),
                _buildPlanCard(
                  context,
                  imageAsset: 'assets/images/plan3.jpg',
                  title: 'Obesity Off',
                  badge: 'Popular',
                  badgeColor: Color(0xB2E6F7F6),
                  description: 'Calorie deficit diet with support',
                  weightLoss: 'Upto 5 kg fat loss/month',
                  originalPrice: '₹2,499',
                  subText: '₹1,499',
                  subTextColor: Colors.black,
                  showCoach: true,
                  showAI: false,
                  showDiscount: true,
                ),
                const SizedBox(height: 20),
                _buildCallSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(bool isActive) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCallSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color.fromRGBO(240, 247, 230, 1), // #F0F7E6
            Color.fromRGBO(230, 240, 250, 1), // #E6F0FA
          ],
          stops: [0.25, 0.45],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Get expert advice to choose the right plan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Chip(
                  backgroundColor: Colors.black,
                  label: Text(
                    'Request a Call',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Positioned circle (adjust offset here)
                Positioned(
                  top: 10, // move up
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF518FBF),
                    ),
                  ),
                ),
                // Image
                Positioned(
                  top: 10,
                  right: -10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/plan_bottom.png',
                      width: 178,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
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
    BuildContext context, {
    required String imageAsset,
    required String title,
    required String badge,
    required Color badgeColor,
    required String description,
    required String weightLoss,
    required String subText,
    required Color subTextColor,
    String? originalPrice,
    bool showCoach = false,
    bool showAI = false,
    bool showDiscount = false,
  }) {
    // Determine if the plan is free
    bool isFreePlan = subText.toLowerCase() == 'free';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEFEE)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222326),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Color(0xFF222326),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showCoach)
                _buildTag('Coach', 'assets/icons/copy.png'),
              if (showAI)
                _buildTag('AI', 'assets/icons/ai_star.png'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageAsset,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF222326),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            weightLoss,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF5B5959),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanDetailScreen(
                                  title: title,
                                  badge: badge,
                                  imageAsset: imageAsset,
                                  description: description,
                                  weightLoss: weightLoss,
                                  originalPrice: originalPrice,
                                  subText: subText,
                                  subTextColor: subTextColor,
                                  showCoach: showCoach,
                                  showAI: showAI,
                                  showDiscount: showDiscount,
                                  isFreePlan: isFreePlan, 
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                               color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                               decoration: TextDecoration.underline,
                               decorationColor:Color(0xFF3C8F7C),
                                   color: Color(0xFF3C8F7C),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (showDiscount)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFFCC1C13),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/coupon_dis.png',
                                  height: 14,
                                  width: 14,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '20% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFreePlan)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFCC00),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              if (originalPrice != null)
                                Text(
                                  originalPrice,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7F7F7F),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                subText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: subTextColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'per month',
                                style: TextStyle(fontSize: 12, color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isFreePlan) {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransformationSupportScreen(
                        
                      ),
                    ),
                  );
                } else {
                  // Navigate to CheckoutScreen for paid plans
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        title: title,
                        badge: badge,
                        imageAsset: imageAsset,
                        description: description,
                        weightLoss: weightLoss,
                        originalPrice: originalPrice,
                        subText: subText,
                        subTextColor: subTextColor,
                        showCoach: showCoach,
                        showAI: showAI,
                        showDiscount: showDiscount,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isFreePlan ? 'Start Free Plan' : 'Choose to Transform',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, String iconPath) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3C8F7C),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 18,
            height: 18,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Handle free plan selection
  
}