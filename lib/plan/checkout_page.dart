import 'package:flutter/material.dart';
import 'dart:async';
import 'package:test_app/plan/transformation_support_screen.dart';
import 'package:test_app/plan/apply_coupon.dart'; // Add this import

class CheckoutScreen extends StatefulWidget {
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
  final bool hasCouponApplied;

  const CheckoutScreen({
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
    this.hasCouponApplied = true,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Timer? _timer;
  int _hours = 0;
  int _minutes = 6;
  int _seconds = 46;
  bool _couponApplied = true;
  String _appliedCouponCode = 'FITDAY20'; // Store the applied coupon code
  int _discountAmount = 500; // Store the discount amount

  @override
  void initState() {
    super.initState();
    _couponApplied = widget.hasCouponApplied;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _seconds = 59;
          _minutes--;
        } else if (_hours > 0) {
          _seconds = 59;
          _minutes = 59;
          _hours--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  // Method to handle coupon application from ApplyCouponScreen
  void _onCouponApplied(String couponCode, int discountAmount) {
    setState(() {
      _couponApplied = true;
      _appliedCouponCode = couponCode;
      _discountAmount = discountAmount;
    });
  }

  // Method to navigate to ApplyCouponScreen
  void _navigateToApplyCoupon() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyCouponScreen(
          onCouponApplied: _onCouponApplied,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image with Timer
            Container(
              width: double.infinity,
              height: 200,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/check_box.jpg',
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                  // Timer Overlay - positioned to extend outside container
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                       
                      ),
                      child: Column(
                        children: [
                           Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3C8F7C),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Limited Offer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ), const SizedBox(height: 0),
                          // Timer Boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildModernTimeBox(_hours.toString().padLeft(2, '0'), 'Hours'),
                              const SizedBox(width: 8),
                              _buildModernTimeBox(_minutes.toString().padLeft(2, '0'), 'Minutes'),
                              const SizedBox(width: 8),
                              _buildModernTimeBox(_seconds.toString().padLeft(2, '0'), 'Seconds'),
                            ],
                          ),
                         
                          
                          // Limited Offer Badge
                         
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Offer Section
                  const Text(
                    'Offer 20% off',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Price Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFDDE5F0)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '₹500',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3C8F7C),
                                ),
                              ),
                              const Text(
                                'Per week',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Billed weekly',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF7F7F7F),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '₹2,000 per month',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7F7F7F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF3C8F7C)),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 8), // Space for badge
                                  const Text(
                                    '₹1,499',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3C8F7C),
                                    ),
                                  ),
                                  const Text(
                                    'per month',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Billed monthly',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF7F7F7F),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '₹375.00 per week',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF7F7F7F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Best Value badge positioned at top left
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Best Value',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
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
                  
                  const SizedBox(height: 20),
                  
                  // Benefits
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Upto 20% off applied',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  
                  // Conditional coupon section
                  if (_couponApplied) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You saved ₹$_discountAmount with "$_appliedCouponCode"',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _couponApplied = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                          ),
                          child: const Text(
                            'Remove',
                            style: TextStyle(
                              color: Color(0xFF3C8F7C),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                    Image.asset(
  "assets/icons/view_all.png",
  width: 24,  // set your desired width
  height: 24, // set your desired height
),

                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _navigateToApplyCoupon, // Updated to call the navigation method
                        child: const Text(
                          'View all coupons',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Order Details
                  Row(
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildOrderRow('Belly Fit', '₹3,000'),
                  _buildOrderRow('Subtotal', '₹3,000'),
                  if (_couponApplied)
                    _buildOrderRow('Discount (20% Off)', '-₹$_discountAmount', isDiscount: true),
                  _buildOrderRow('Taxes & Charges', '₹500', hasInfo: true),
                  
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: const Color(0xFFE5E5E5),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildOrderRow(
                    'Total', 
                    _couponApplied ? '₹${3000 + 500 - _discountAmount}' : '₹3,499', 
                    isBold: true
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
            
            // Bottom price bar with coupon icon, prices and button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left side - Coupon icon and prices
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '20% off',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '₹3,000',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  _couponApplied ? '₹${3000 + 500 - _discountAmount}' : '₹3,499',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  ' per month',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Right side - Subscribe button
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransformationSupportScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Subscribe Now',
                        style: TextStyle(
                          fontSize: 12,
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
      ),
    );
  }

Widget _buildModernTimeBox(String time, String label) {
  return Container(
    width: 74,
    height: 60,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 240, 245, 244),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Color(0xFF3C8F7C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3C8F7C),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildOrderRow(String label, String amount, {
    bool isDiscount = false, 
    bool isBold = false, 
    bool hasInfo = false
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isBold ? 16 : 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              if (hasInfo) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showTaxesModal,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 10,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showTaxesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Taxes & Charges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTaxRow('GST 18%', '₹1,000'),
            const SizedBox(height: 12),
            _buildTaxRow('Google play 30%', '₹1,000'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}