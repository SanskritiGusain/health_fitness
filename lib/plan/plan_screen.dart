import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Import the detail screen
import 'package:test_app/plan/plan_detail.dart';
// Import the checkout screen
import 'package:test_app/plan/checkout_page.dart';
import 'package:test_app/call/schedule_call.dart';
import 'package:test_app/plan/transformation_support_screen.dart';

// Plan model to handle API data
class Plan {
  final int id;
  final String name;
  final String description;
  final String tag;
  final int price;
  final int weeklyPrice;
  final int monthlyPrice;
  final int oldWeeklyPrice;
  final int oldMonthlyPrice;
  final int oldPrice;
  final bool isFree;
  final String imageUrl;
  final bool isPopular;
  final bool isBestSeller;
  final String highlightLine;
  final int discountPercent;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.price,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.oldWeeklyPrice,
    required this.oldMonthlyPrice,
    required this.oldPrice,
    required this.isFree,
    required this.imageUrl,
    required this.isPopular,
    required this.isBestSeller,
    required this.highlightLine,
    required this.discountPercent,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      tag: json['tag']?.toString() ?? '',
      price: _toInt(json['price']),
      weeklyPrice: _toInt(json['weekly_price']),
      monthlyPrice: _toInt(json['monthly_price']),
      oldWeeklyPrice: _toInt(json['old_weekly_price']),
      oldMonthlyPrice: _toInt(json['old_monthly_price']),
      oldPrice: _toInt(json['old_price']),
      isFree: json['is_free'] ?? false,
      imageUrl: json['image_url']?.toString() ?? '',
      isPopular: json['is_popular'] ?? false,
      isBestSeller: json['is_best_seller'] ?? false,
      highlightLine: json['highlight_line']?.toString() ?? '',
      discountPercent: _toInt(json['discount_percent']),
    );
  }

  // Helper method to safely convert dynamic values to int
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get badgeText {
    if (isBestSeller) return 'Best Seller';
    if (isPopular) return 'Popular';
    if (tag.isNotEmpty) return tag;
    return 'Recommend';
  }

  String get priceText {
    if (isFree) return 'Free';
    return '₹${monthlyPrice > 0 ? monthlyPrice : price}';
  }

  String? get originalPriceText {
    if (isFree) return null;
    int originalPrice = oldMonthlyPrice > 0 ? oldMonthlyPrice : oldPrice;
    return originalPrice > 0 ? '₹$originalPrice' : null;
  }

  bool get hasDiscount => discountPercent > 0;
}

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<Plan> plans = [];
  bool isLoading = true;
  String? errorMessage;
  
  // Base URL for your server
  static const String baseUrl = 'http://192.168.1.7:8000';
  
  // Progress tracking
  int currentStep = 4;
  int totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  // Helper method to get full image URL
  String _getFullImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    // Remove leading slash if present and add base URL
    final cleanPath = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
    return '$baseUrl/$cleanPath';
  }

  Future<void> _loadPlans() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse('$baseUrl/plans/'),
        headers: {'accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        if (responseData is List) {
          final List<Plan> loadedPlans = [];
          
          for (int i = 0; i < responseData.length; i++) {
            try {
              final plan = Plan.fromJson(responseData[i] as Map<String, dynamic>);
              loadedPlans.add(plan);
              print('Successfully parsed plan ${i + 1}: ${plan.name}');
            } catch (e) {
              print('Error parsing plan ${i + 1}: $e');
              print('Plan data: ${responseData[i]}');
              // Continue with other plans instead of failing completely
            }
          }
          
          setState(() {
            plans = loadedPlans;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Invalid response format: Expected array but got ${responseData.runtimeType}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load plans: HTTP ${response.statusCode}\n${response.body}';
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading plans: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Error loading plans: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Colors.black,
            size: isSmallScreen ? 20 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 16),
          child: Container(
            height: isSmallScreen ? 3 : 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: currentStep / totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
         // In your build method, replace the title section with this fixed version:

Padding(
  padding: EdgeInsets.symmetric(
    horizontal: isTablet ? 24.0 : 16.0,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: screenHeight * 0.01),
      Container(
        width: double.infinity, // This ensures the container takes full width
        alignment: Alignment.centerLeft, // This explicitly left-aligns the content
        child: Text(
          'Best Recommended Plans for You',
          style: TextStyle(
            fontSize: isTablet ? 26 : (isSmallScreen ? 20 : 22),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.left, // This ensures the text itself is left-aligned
        ),
      ),
      SizedBox(height: screenHeight * 0.02),
    ],
  ),
),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32.0 : 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: isTablet ? 80 : 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 18 : 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _loadPlans();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 24,
                    vertical: isTablet ? 16 : 12,
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPlans,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0),
        children: [
          ...plans.map((plan) => Padding(
                padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                child: _buildPlanCard(context, plan),
              )),
          SizedBox(height: isTablet ? 32 : 20),
          _buildCallSection(),
          SizedBox(height: isTablet ? 32 : 20),
        ],
      ),
    );
  }

  Widget _buildCallSection() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color.fromRGBO(240, 247, 230, 1),
            Color.fromRGBO(230, 240, 250, 1),
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
              children: [
                Text(
                  'Get expert advice to choose the right plan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 17 : (isSmallScreen ? 13 : 15),
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),
                InkWell(
                  onTap: () {
                    // Handle call request
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleCallScreen(
                        
                      ),
                    ),
                  ); 
                  },
                  child: Chip(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 8 : 4,
                    ),
                    label: Text(
                      'Request a Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          SizedBox(
            width: isTablet ? 120 : 100,
            height: isTablet ? 120 : 100,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 10,
                  child: Container(
                    width: isTablet ? 115 : 95,
                    height: isTablet ? 115 : 95,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF518FBF),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: isTablet ? -15 : -10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/plan_bottom.png',
                      width: isTablet ? 200 : 178,
                      height: isTablet ? 130 : 110,
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

  Widget _buildPlanCard(BuildContext context, Plan plan) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;
    final imageSize = isTablet ? 100.0 : (isSmallScreen ? 70.0 : 80.0);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEFEE)),
      ),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF222326),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6, 
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xB2E6F7F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        plan.badgeText,
                        style: TextStyle(
                          color: const Color(0xFF222326),
                          fontSize: isTablet ? 13 : (isSmallScreen ? 10 : 12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!plan.isFree)
                _buildTag('Coach', 'assets/icons/copy.png'),
              if (plan.isFree)
                _buildTag('AI', 'assets/icons/ai_star.png'),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: plan.imageUrl.isNotEmpty
                    ? Image.network(
                        _getFullImageUrl(plan.imageUrl),
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: imageSize,
                            height: imageSize,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: Colors.grey[400],
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: ${_getFullImageUrl(plan.imageUrl)}');
                          print('Error: $error');
                          return Container(
                            width: imageSize,
                            height: imageSize,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported, 
                                     color: Colors.grey[400], 
                                     size: isTablet ? 28 : 24),
                                Text('Image\nError', 
                                     style: TextStyle(
                                       color: Colors.grey[600], 
                                       fontSize: isTablet ? 10 : 8
                                     ),
                                     textAlign: TextAlign.center),
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        width: imageSize,
                        height: imageSize,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, 
                               color: Colors.grey[400], 
                               size: isTablet ? 32 : 24),
                      ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.description,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222326),
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.highlightLine.isNotEmpty 
                                ? plan.highlightLine 
                                : 'Transform your fitness journey',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF5B5959),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanDetailScreen(
                                  planId: plan.id,
                                  title: plan.name,
                                  badge: plan.badgeText,
                                  imageAsset: _getFullImageUrl(plan.imageUrl),
                                  description: plan.description,
                                  weightLoss: plan.highlightLine,
                                  originalPrice: plan.originalPriceText,
                                  subText: plan.priceText,
                                  subTextColor: plan.isFree ? const Color(0xFFFFCC00) : Colors.black,
                                  showCoach: !plan.isFree,
                                  showAI: plan.isFree,
                                  showDiscount: plan.hasDiscount,
                                  isFreePlan: plan.isFree,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'View Details',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFF3C8F7C),
                                color: const Color(0xFF3C8F7C),
                                fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 10 : 8),
                    if (plan.hasDiscount)
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 8 : 6, 
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCC1C13),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/coupon_dis.png',
                                  height: isTablet ? 16 : 14,
                                  width: isTablet ? 16 : 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${plan.discountPercent}% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 12 : 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: isTablet ? 6 : 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plan.isFree)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 10 : 8, 
                              vertical: isTablet ? 4 : 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCC00),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              if (plan.originalPriceText != null)
                                Text(
                                  plan.originalPriceText!,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    color: const Color(0xFF7F7F7F),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                plan.priceText,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'per month',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12, 
                                  color: const Color(0xFF000000),
                                ),
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
          SizedBox(height: isTablet ? 16 : 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (plan.isFree) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransformationSupportScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        title: plan.name,
                        badge: plan.badgeText,
                        imageAsset: _getFullImageUrl(plan.imageUrl),
                        description: plan.description,
                        weightLoss: plan.highlightLine,
                        originalPrice: plan.originalPriceText,
                        subText: plan.priceText,
                        subTextColor: Colors.black,
                        showCoach: !plan.isFree,
                        showAI: plan.isFree,
                        showDiscount: plan.hasDiscount,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                plan.isFree ? 'Start Free Plan' : 'Choose to Transform',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, String iconPath) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;
    
    return Container(
      margin: EdgeInsets.only(left: isTablet ? 8 : 6),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 10 : 8, 
        vertical: isTablet ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF3C8F7C),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: isTablet ? 20 : 18,
            height: isTablet ? 20 : 18,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}