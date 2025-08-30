import 'package:flutter/material.dart';
import 'dart:async';
import 'package:test_app/plan/transformation_support_screen.dart';
import 'package:test_app/plan/apply_coupon.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  String _appliedCouponCode = 'FITDAY20';
  int _discountAmount = 500;
  int selectedPlanIndex = 1;
  bool _isLoading = false;

  // Pricing constants for better maintainability
  static const int _basePrice = 3000;
  static const int _taxesAndCharges = 500;
  static const double _discountPercentage = 0.20;

  @override
  void initState() {
    super.initState();
    _couponApplied = widget.hasCouponApplied;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

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
          _showTimerExpiredDialog();
        }
      });
    });
  }

  void _showTimerExpiredDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Offer Expired'),
            content: const Text(
              'The limited time offer has expired. Regular pricing now applies.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _onCouponApplied(String couponCode, int discountAmount) {
    setState(() {
      _couponApplied = true;
      _appliedCouponCode = couponCode;
      _discountAmount = discountAmount;
    });
    _showSnackBar('Coupon applied successfully!', Colors.green);
  }

  void _navigateToApplyCoupon() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ApplyCouponScreen(onCouponApplied: _onCouponApplied),
      ),
    );
  }

  void _removeCoupon() {
    setState(() {
      _couponApplied = false;
    });
    _showSnackBar('Coupon removed', Colors.orange);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _calculateTotal() {
    int total = _basePrice + _taxesAndCharges;
    if (_couponApplied) {
      total -= _discountAmount;
    }
    return total;
  }

  Future<void> _handleSubscription() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransformationSupportScreen()),
      );
    } catch (e) {
      _showSnackBar('Subscription failed. Please try again.', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
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
        child: Column(children: [_buildTimerSection(), _buildMainContent()]),
      ),
      bottomNavigationBar: _buildBottomPriceBar(),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 66,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C8F7C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Limited Offer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModernTimeBox(
                        _hours.toString().padLeft(2, '0'),
                        'Hours',
                      ),
                      const SizedBox(width: 8),
                      _buildModernTimeBox(
                        _minutes.toString().padLeft(2, '0'),
                        'Minutes',
                      ),
                      const SizedBox(width: 8),
                      _buildModernTimeBox(
                        _seconds.toString().padLeft(2, '0'),
                        'Seconds',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildOfferHeader(),
          const SizedBox(height: 20),
          _buildPricingSection(context),
          const SizedBox(height: 20),
          _buildBenefitsSection(),
          const SizedBox(height: 24),
          _buildOrderDetails(),
        ],
      ),
    );
  }

  Widget _buildOfferHeader() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Offer ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '20%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
          TextSpan(
            text: ' off',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Container(
      color: Colors.white, // White background
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBenefitRow('Upto 20% off applied'),
          if (_couponApplied) ...[
            const SizedBox(height: 18),
            _buildCouponAppliedRow(),
          ],
          const SizedBox(height: 12),

          // Dotted line
          const DottedLine(
            dashLength: 6,
            dashGapLength: 4,
            lineThickness: 1,
            dashColor: Colors.grey,
          ),

          const SizedBox(height: 12),
          _buildViewCouponsRow(),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: Colors.teal, size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCouponAppliedRow() {
    return Row(
      children: [
        const Icon(Icons.check, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'You saved ₹$_discountAmount with "$_appliedCouponCode"',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: _removeCoupon,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
          ),
          child: const Text(
            'Remove',
            style: TextStyle(color: Color(0xFF3C8F7C), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildViewCouponsRow() {
    return Row(
      children: [
        Image.asset("assets/icons/view_all.png", width: 24, height: 24),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _navigateToApplyCoupon,
          child: const Text(
            'View all coupons',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        const Row(
          children: [
            Text(
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

        _buildOrderRow('Subtotal', '₹$_basePrice'),
        _buildOrderRow('Discount (20% Off)', '₹$_basePrice'),
        if (_couponApplied)
          _buildOrderRow(
            'Discount (20% Off)',
            '-₹$_discountAmount',
            isDiscount: true,
          ),
        _buildOrderRow('Taxes & Charges', '₹$_taxesAndCharges', hasInfo: true),
        const SizedBox(height: 16),
        Container(height: 1, color: const Color(0xFFE5E5E5)),
        const SizedBox(height: 16),
        _buildOrderRow('Total', '₹${_calculateTotal()}', isBold: true),
      ],
    );
  }

  Widget _buildBottomPriceBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                       
                        SvgPicture.asset(
                          'assets/icons_update/solar_tag-linear.svg',
                        ),
                        SizedBox(width: 8),
                        Text(
                          '20% off',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '₹3,000',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${_calculateTotal()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          ' per month',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    const Text(
                      ' Incl. taxes and charges',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        'Subscribe Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTimeBox(String time, String label) {
    return Container(
      width: 94,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF3C8F7C),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF3C8F7C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isTablet ? 12 : 6),
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
            margin: EdgeInsets.only(left: isTablet ? 12 : 6),
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
          Container(
            width: double.infinity,
            height: cardHeight,
            padding: EdgeInsets.all(isTablet ? 18 : 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? const Color(0xFF3C8F7C) : Colors.grey.shade300,
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
                    color: bestValue ? const Color(0xFF3C8F7C) : Colors.black,
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
                    color: const Color.fromARGB(255, 85, 83, 83),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildOrderRow(
    String label,
    String amount, {
    bool isDiscount = false,
    bool isBold = false,
    bool hasInfo = false,
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
                  fontSize: isBold ? 18 : 16,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              if (hasInfo) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showTaxesModal,
                  child: Container(
                    child: const Icon(
                      Icons.info_outline,
                      size: 18,
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
              fontSize: isBold ? 18 : 16,
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
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 10),
                Container(height: 1, color: const Color(0xFFE5E5E5)),
                const SizedBox(height: 10),
                _buildTaxRow('GST 18%', '₹270'),
                const SizedBox(height: 12),
                _buildTaxRow('Platform Fee', '₹230'),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildTaxRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
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
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 12, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
