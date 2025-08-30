import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlanDetailScreen extends StatefulWidget {
  final int planId; // Add plan ID parameter
  final String title;
  final String badge;
  final String imageAsset;
  final String description;
  final String weightLoss;
  final String? originalPrice;
  final String subText;
  final Color subTextColor;
  final bool showCoach;
  final bool showAI;
  final bool showDiscount;
  final bool isFreePlan;

  const PlanDetailScreen({
    super.key,
    required this.planId, // Make plan ID required
    required this.title,
    required this.badge,
    required this.imageAsset,
    required this.description,
    required this.weightLoss,
    this.originalPrice,
    required this.subText,
    required this.subTextColor,
    this.showCoach = false,
    this.showAI = false,
    this.showDiscount = false,
    required this.isFreePlan,
  });

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  Map<String, dynamic>? planDetails;
  bool isLoading = true;
  String? errorMessage;

  static const String baseUrl = 'http://192.168.1.12:8000';

  @override
  void initState() {
    super.initState();
    _loadPlanDetails();
  }

  Future<void> _loadPlanDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse('$baseUrl/plans/${widget.planId}'),
        headers: {'accept': 'application/json'},
      );

      print('Loading plan details for ID: ${widget.planId}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          planDetails = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load plan details: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading plan details: $e');
      setState(() {
        errorMessage = 'Error loading plan details: $e';
        isLoading = false;
      });
    }
  }

  // Helper method to get full image URL
  String _getFullImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    // Remove leading slash if present and add base URL
    final cleanPath =
        imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
    return '$baseUrl/$cleanPath';
  }

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
        title: const Text(
          'Back to plans',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        _loadPlanDetails();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildImageTitleContainer(),
                          const SizedBox(height: 16),
                          if (widget.isFreePlan) ...[
                            _buildFreePlanOverview(),
                            const SizedBox(height: 16),
                            _buildDetailedDescriptionContainer(),
                          ] else ...[
                            _buildPaidPlanSection(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _buildSubscribeButtonContainer(),
                ],
              ),
    );
  }

  Widget _buildFreePlanOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Program Overview', style: _headingStyle),
          const SizedBox(height: 16),
          const Text('Target Audience', style: _labelStyle),
          Text(
            planDetails?['target_audience'] ??
                planDetails?['tag'] ??
                'General fitness',
            style: _valueStyle,
          ),
          const SizedBox(height: 16),
          const Text('Focus Areas', style: _labelStyle),
          Text(
            planDetails?['focus_area'] ??
                planDetails?['description'] ??
                'Core workouts • fat-burning foods',
            style: _valueStyle,
          ),
          const SizedBox(height: 30),
          const Text('Key Features', style: _labelStyle),
          const SizedBox(height: 10),
          // Use key_features from API if available
          if (planDetails?['key_features'] != null &&
              planDetails!['key_features'] is List)
            ...List<Widget>.from(
              (planDetails!['key_features'] as List).map(
                (feature) => _buildFeatureItem('• $feature'),
              ),
            )
          else ...[
            _buildFeatureItem('• Daily activity tasks'),
            _buildFeatureItem('• Personalized meal plan'),
            _buildFeatureItem('• Body metrics progress report'),
            _buildFeatureItem(
              '• ${widget.isFreePlan ? 'AI chat support' : 'Expert coach support'}',
            ),
          ],

          // Show highlight line if available
          if (planDetails?['highlight_line'] != null &&
              planDetails!['highlight_line'].toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFF3C8F7C), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      planDetails!['highlight_line'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C8F7C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaidPlanSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildFeatureRow('Targeted')),
            const SizedBox(width: 12),
            Expanded(child: _buildFeatureRow('Expert')),
          ],
        ),
        const SizedBox(height: 20),
        _buildFreePlanOverview(),
      ],
    );
  }

  Widget _buildFeatureRow(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEFEE)),
      ),
      child: Column(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF222326),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTitleContainer() {
    // Use API image URL if available, otherwise fall back to widget image
    final imageUrl = planDetails?['image_url'] ?? widget.imageAsset;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        _getFullImageUrl(imageUrl),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 48,
                          ),
                        ),
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      planDetails?['name'] ?? widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222326),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xB2E6F7F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        planDetails?['tag'] ?? widget.badge,
                        style: const TextStyle(
                          color: Color(0xFF222326),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  planDetails?['description'] ?? widget.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF5B5959),
                  ),
                ),
                const SizedBox(height: 8),
                if (planDetails?['highlight_line'] != null &&
                    planDetails!['highlight_line'].toString().isNotEmpty)
                  Text(
                    planDetails!['highlight_line'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3C8F7C),
                    ),
                  )
                else
                  Text(
                    widget.weightLoss,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3C8F7C),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedDescriptionContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detailed Description', style: _headingStyle),
          const SizedBox(height: 20),
          Text(
            planDetails?['detailed_description'] ??
                planDetails?['description'] ??
                'This comprehensive program includes personalized meal plans, workout routines, and ongoing support to ensure you reach your transformation goals.',
            style: _valueStyle,
          ),
          const SizedBox(height: 20),
          Text(
            'This program is specifically designed to help you achieve sustainable results through a combination of targeted exercises, nutritional guidance, and expert support.',
            style: _valueStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButtonContainer() {
    if (widget.isFreePlan) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Free plan subscription initiated!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Subscribe for free',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    // Paid plan bottom layout
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Show discount if available from API
              if (widget.showDiscount &&
                  (planDetails?['discount_percent'] ?? 0) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC1C13),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${planDetails?['discount_percent'] ?? 20}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.showDiscount &&
                  (planDetails?['discount_percent'] ?? 0) > 0)
                const SizedBox(width: 12),

              // Show original price if available
              if (planDetails?['old_monthly_price'] != null &&
                  planDetails!['old_monthly_price'] > 0)
                Text(
                  '₹${planDetails!['old_monthly_price']}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7F7F7F),
                  ),
                ),
              if (planDetails?['old_monthly_price'] != null &&
                  planDetails!['old_monthly_price'] > 0)
                const SizedBox(width: 8),

              // Show current price
              Text(
                '₹${planDetails?['monthly_price'] ?? planDetails?['price'] ?? widget.subText.replaceAll('₹', '')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'per month',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Proceeding to checkout for ${planDetails?['name'] ?? widget.title}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Subscribe now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF222326),
          height: 1.4,
        ),
      ),
    );
  }

  static const _headingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF222326),
  );

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF222326),
  );

  static const _valueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF222326),
    height: 1.4,
  );
}
