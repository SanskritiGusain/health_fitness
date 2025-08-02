import 'package:flutter/material.dart';

class ApplyCouponScreen extends StatefulWidget {
  final Function(String, int) onCouponApplied;

  const ApplyCouponScreen({
    super.key,
    required this.onCouponApplied,
  });

  @override
  _ApplyCouponScreenState createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final TextEditingController _couponController = TextEditingController();
  
  final List<Map<String, dynamic>> availableCoupons = [
    {
      'code': 'FITDAY20',
      'description': 'Save ₹125.00 with this code',
      
      'discount': 125,
    },
    {
      'code': 'NEWUSER30',
      'description': 'Save ₹200.00 with this code',
    
      'discount': 200,
    },
    {
      'code': 'SAVE50',
      'description': 'Save ₹500.00 with this code',
   
      'discount': 500,
    },
  ];

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
          'Apply Coupon',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coupon Input Section
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _couponController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a coupon code',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF757575),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _applyCouponByCode(_couponController.text);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Available Coupons Title
            const Text(
              'Available Coupons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Available Coupons List
            Expanded(
              child: ListView.builder(
                itemCount: availableCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = availableCoupons[index];
                  return _buildCouponCard(coupon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align all items to center
        children: [
          // Coupon Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF3C8F7C).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer,
              color: Color(0xFF3C8F7C),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Coupon Details - In column format
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Coupon Code
                Text(
                  coupon['code'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  coupon['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                // Sub Text
               
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Apply Button
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF3C8F7C)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextButton(
              onPressed: () {
                widget.onCouponApplied(coupon['code'], coupon['discount']);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
              child: const Text(
                'APPLY',
                style: TextStyle(
                  color: Color(0xFF3C8F7C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyCouponByCode(String code) {
    if (code.isEmpty) return;
    
    // Find coupon by code
    final coupon = availableCoupons.firstWhere(
      (c) => c['code'].toLowerCase() == code.toLowerCase(),
      orElse: () => {},
    );
    
    if (coupon.isNotEmpty) {
      widget.onCouponApplied(coupon['code'], coupon['discount']);
      Navigator.pop(context);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
}