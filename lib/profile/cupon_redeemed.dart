import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard

class CouponRedeemedDialog extends StatelessWidget {
  final String couponCode;

  const CouponRedeemedDialog({super.key, this.couponCode = "FITDAY20"});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(0, 249, 248, 248),
      child: Stack(
        children: [
          // Main content box
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDFFFEA), Color(0xFFEAF9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎉 Coupon Redeemed Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '🎉 ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Coupon Redeemed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

              // Coupon Code Display in a Container with borderRadius
Container(
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  width: 244,
  height: 104,
  decoration: BoxDecoration(
    // color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Color(0xFF3C8F7C)),
  ),
  child: Column(
    children: [
      Text(
        'Your Coupon Code',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[800],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          couponCode,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
           
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: 20),


                // Copy Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: couponCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Coupon code copied!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.teal[600],
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text(
                      'Copy Coupon Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close Icon on top-right
          Positioned(
            top: 28,
            right: 5,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(6),
              
                child: const Icon(Icons.close, size: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
