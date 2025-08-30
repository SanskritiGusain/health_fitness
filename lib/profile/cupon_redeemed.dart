import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponRedeemedDialog extends StatefulWidget {
  final String couponCode;

  const CouponRedeemedDialog({super.key, this.couponCode = "HEALTH20"});

  @override
  State<CouponRedeemedDialog> createState() => _CouponRedeemedDialogState();
}

class _CouponRedeemedDialogState extends State<CouponRedeemedDialog> {
  bool _isCopied = false;

  void _copyCoupon() {
    Clipboard.setData(ClipboardData(text: widget.couponCode));
    setState(() {
      _isCopied = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      content: Stack(
        children: [
          // Main content box
          Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD7F2D3), Color(0xFFC3DEF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎉 Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🎉 ', style: TextStyle(fontSize: 22)),
                    Text(
                      'Coupon Redeemed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Coupon Code Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF3C8F7C)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Coupon Code',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.couponCode,
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

                // Copy button OR Copied state
              _isCopied
    ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons_update/tabler_checkbox.svg',
            width: 24,  // adjust size as needed
            height: 24,
            color: Colors.black, // optional (only works if SVG has no hardcoded color)
          ),
          const SizedBox(width: 6),
          const Text(
            "Copied",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      )
                 : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _copyCoupon,
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text(
                          'Copy Coupon Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
              ],
            ),
          ),

          // Close Icon
          Positioned(
            top: 10,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.close, size: 22, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage
void showCouponDialog(BuildContext context, {String couponCode = "HEALTH20"}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return CouponRedeemedDialog(couponCode: couponCode);
    },
  );
}
