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

class _PlanScreenState extends State<PlanScreen> with TickerProviderStateMixin {
  List<Plan> plans = [];
  bool isLoading = true;
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Base URL for your server
  static const String baseUrl = 'http://192.168.1.12:8000';

  // Progress tracking
  int currentStep = 4;
  int totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadPlans();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              final plan = Plan.fromJson(
                responseData[i] as Map<String, dynamic>,
              );
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
          
          // Start animation after data is loaded
          _animationController.forward();
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
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: isSmallScreen ? 20 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Step $currentStep of $totalSteps',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${((currentStep / totalSteps) * 100).round()}%',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3C8F7C), Color(0xFF2ECC71)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          // Enhanced title section with animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best Recommended Plans',
                          style: TextStyle(
                            fontSize: isTablet ? 28 : (isSmallScreen ? 22 : 24),
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'for You',
                          style: TextStyle(
                            fontSize: isTablet ? 28 : (isSmallScreen ? 22 : 24),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3C8F7C),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Choose the perfect plan to transform your health journey',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                ],
              ),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
      // Enhanced bottom navigation or action area
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24.0 : 16.0,
          vertical: isTablet ? 20 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Need help choosing? Our experts are here to assist you',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleCallScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.phone,
                color: Color(0xFF3C8F7C),
                size: 16,
              ),
              label: Text(
                'Get Help',
                style: TextStyle(
                  color: const Color(0xFF3C8F7C),
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 14 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF3C8F7C),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your personalized plans...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: isTablet ? 80 : 64,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t load your plans right now. Please try again.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTablet ? 16 : 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadPlans,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C8F7C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 24,
                    vertical: isTablet ? 16 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  'Try Again',
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
      color: const Color(0xFF3C8F7C),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0),
        children: [
          // Plans list with staggered animation
          ...plans.asMap().entries.map(
            (entry) => FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    entry.key * 0.1,
                    (entry.key * 0.1) + 0.6,
                    curve: Curves.easeOutCubic,
                  ),
                )),
                child: Padding(
                  padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
                  child: _buildEnhancedPlanCard(context, entry.value),
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildEnhancedCallSection(),
          ),
          SizedBox(height: isTablet ? 40 : 30),
        ],
      ),
    );
  }

  Widget _buildEnhancedCallSection() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F7E6),
            Color(0xFFE6F0FA),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3C8F7C).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Need Expert Guidance?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  'Get personalized advice to choose the perfect plan for your goals',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 15 : (isSmallScreen ? 12 : 13),
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleCallScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C8F7C),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 12 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: Icon(
                    Icons.phone_callback_rounded,
                    size: isTablet ? 18 : 16,
                  ),
                  label: Text(
                    'Schedule a Call',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          Container(
            width: isTablet ? 120 : 100,
            height: isTablet ? 120 : 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/plan_bottom.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C8F7C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: const Color(0xFF3C8F7C),
                      size: isTablet ? 50 : 40,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPlanCard(BuildContext context, Plan plan) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;
    final imageSize = isTablet ? 100.0 : (isSmallScreen ? 70.0 : 80.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.isPopular || plan.isBestSeller 
              ? const Color(0xFF3C8F7C).withOpacity(0.3)
              : const Color(0xFFECEFEE),
          width: plan.isPopular || plan.isBestSeller ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with plan name and badges
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
                          fontSize: isTablet ? 20 : (isSmallScreen ? 16 : 18),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF222326),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 10 : 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: plan.isPopular || plan.isBestSeller 
                            ? const Color(0xFF3C8F7C)
                            : const Color(0xB2E6F7F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.badgeText,
                        style: TextStyle(
                          color: plan.isPopular || plan.isBestSeller 
                              ? Colors.white
                              : const Color(0xFF222326),
                          fontSize: isTablet ? 12 : (isSmallScreen ? 10 : 11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!plan.isFree) _buildEnhancedTag('Coach', 'assets/icons/copy.png'),
              if (plan.isFree) _buildEnhancedTag('AI', 'assets/icons/ai_star.png'),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          
          // Content row with image and details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced image container
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                              color: Colors.grey[100],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: const Color(0xFF3C8F7C),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_rounded,
                                    color: Colors.grey[400],
                                    size: isTablet ? 32 : 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Image\nUnavailable',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: isTablet ? 10 : 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          width: imageSize,
                          height: imageSize,
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.fitness_center_rounded,
                            color: const Color(0xFF3C8F7C),
                            size: isTablet ? 36 : 32,
                          ),
                        ),
                ),
              ),
              SizedBox(width: isTablet ? 20 : 16),
              
              // Plan details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.description,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222326),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 6),
                    Text(
                      plan.highlightLine.isNotEmpty
                          ? plan.highlightLine
                          : 'Transform your fitness journey with personalized guidance',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : (isSmallScreen ? 11 : 12),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF5B5959),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 10),
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
                              subTextColor: plan.isFree
                                  ? const Color(0xFFFFCC00)
                                  : Colors.black,
                              showCoach: !plan.isFree,
                              showAI: plan.isFree,
                              showDiscount: plan.hasDiscount,
                              isFreePlan: plan.isFree,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 10,
                          vertical: isTablet ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C8F7C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'View Details →',
                          style: TextStyle(
                            color: const Color(0xFF3C8F7C),
                            fontSize: isTablet ? 13 : (isSmallScreen ? 11 : 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: isTablet ? 16 : 12),
          
          // Discount badge
          if (plan.hasDiscount)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 10,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFCC1C13)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCC1C13).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        color: Colors.white,
                        size: isTablet ? 16 : 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${plan.discountPercent}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 12 : 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          
          SizedBox(height: isTablet ? 12 : 8),
          
          // Price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (plan.isFree)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE082), Color(0xFFFFCC02)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFCC02).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    if (plan.originalPriceText != null) ...[
                      Text(
                        plan.originalPriceText!,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey[500],
                          decorationThickness: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      plan.priceText,
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3C8F7C),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              if (plan.hasDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SAVE ${plan.discountPercent}%',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          
          SizedBox(height: isTablet ? 20 : 16),
          
          // Action button
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
                backgroundColor: plan.isFree 
                    ? const Color(0xFFFFCC02)
                    : const Color(0xFF3C8F7C),
                foregroundColor: plan.isFree ? Colors.black87 : Colors.white,
                padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: (plan.isFree 
                    ? const Color(0xFFFFCC02)
                    : const Color(0xFF3C8F7C)).withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plan.isFree ? 'Start Free Plan' : 'Choose to Transform',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    plan.isFree ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                    size: isTablet ? 20 : 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTag(String label, String iconPath) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isTablet = screenSize.width > 600;

    return Container(
      margin: EdgeInsets.only(left: isTablet ? 8 : 6),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3C8F7C), Color(0xFF2ECC71)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3C8F7C).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: isTablet ? 18 : 16,
            height: isTablet ? 18 : 16,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                label == 'AI' ? Icons.psychology_rounded : Icons.person_rounded,
                color: Colors.white,
                size: isTablet ? 18 : 16,
              );
            },
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}