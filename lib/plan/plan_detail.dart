import 'package:flutter/material.dart';

class PlanDetailScreen extends StatelessWidget {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildImageTitleContainer(),
                  const SizedBox(height: 16),
                  if (isFreePlan) ...[
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
          const Text('General obesity', style: _valueStyle),
          const SizedBox(height: 16),
          const Text('Focus Areas', style: _labelStyle),
          const Text('Core workouts • fat-burning foods', style: _valueStyle),
          const SizedBox(height: 30),
          const Text('Key Features', style: _labelStyle),
          const SizedBox(height: 10),
          _buildFeatureItem('• Daily activity tasks'),
          _buildFeatureItem('• No-sugar meal plan'),
          _buildFeatureItem('• Body metrics progress report'),
          _buildFeatureItem('• Chat with AI for your questions'),
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
          Image.asset(
            'assets/icons/target_icon.png', // Use your star icon asset
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 10),
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
              child: Transform.translate(
                offset: const Offset(0, -35),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222326),
              ),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detailed Description', style: _headingStyle),
          SizedBox(height: 20),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod...',
            style: _valueStyle,
          ),
          SizedBox(height: 20),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod...',
            style: _valueStyle,
          ),
          SizedBox(height: 20),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod...',
            style: _valueStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButtonContainer() {
    if (isFreePlan) {
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
              // TODO: Handle free plan subscription
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Subscribe for free',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
          // Single row with discount, original price, and current price
          Row(
            children: [
              if (showDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC1C13),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/coupon_dis.png', width: 16, height: 16),
                      const SizedBox(width: 6),
                      const Text(
                        '20% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (showDiscount) const SizedBox(width: 12),
              if (originalPrice != null)
                Text(
                  originalPrice!,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7F7F7F),
                  ),
                ),
              if (originalPrice != null) const SizedBox(width: 8),
              Text(
                subText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'per month',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Handle paid plan subscription
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Subscribe now',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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