import 'package:flutter/material.dart';
import 'dart:async';
import 'package:test_app/plan/transformation_support_screen.dart';

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
    this.hasCouponApplied = true, // Set to false to show image 1, true for image 2
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
                    widget.imageAsset,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  // Timer Overlay
                  Positioned(
                    top: 110,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                      
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left:20,right:20,top:2,bottom: 2),
                          
// ✅ Correct way
 decoration: BoxDecoration(
 color: const Color(0xFF3C8F7C),
    borderRadius: BorderRadius.all(Radius.circular(10)), // ✅ Correct
// ✅ Correct
  ),
                             
                           child:Text(
                              
                            'Limited Offer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),),
                          // const SizedBox(height:8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeBox(_hours.toString().padLeft(2, '0')),
                              const SizedBox(width: 8),
                              _buildTimeBox(_minutes.toString().padLeft(2, '0')),
                              const SizedBox(width: 8),
                              _buildTimeBox(_seconds.toString().padLeft(2, '0')),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Hours', style: TextStyle( color:  Color(0xFF3C8F7C), fontSize: 10)),
                              SizedBox(width: 20),
                              Text('Minutes', style: TextStyle(color:  Color(0xFF3C8F7C), fontSize: 10)),
                              SizedBox(width: 15),
                              Text('Seconds', style: TextStyle(color:  Color(0xFF3C8F7C), fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offer Section
                  const Text(
                    'Offer 20% off',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Price Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFDDE5F0)),
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
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFF3C8F7C)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 21, 21, 21),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Best Value',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color.fromARGB(255, 223, 218, 218),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
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
                                'Billed weekly',
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
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Benefits
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Upto 20% off applied', 
                        style: TextStyle(fontSize: 14)
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
                        const Expanded(
                          child: Text(
                            'You saved ₹500 with "FITDAY20"',
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
                            minimumSize: Size(0, 0),
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
                  GestureDetector(
                    onTap: () {
                      // Handle view all coupons
                    },
                    child: const Text(
                      'View all coupons ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Order Details
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildOrderRow('Belly Fit', '₹3,000'),
                  _buildOrderRow('Subtotal', '₹3,000'),
                  if (_couponApplied)
                    _buildOrderRow('Discount (20% Off)', '-₹1,000', isDiscount: true),
                  _buildOrderRow('Taxes & Charges', '₹500', hasInfo: true),
                  
                  const Divider(height: 24, color: Colors.grey),
                  
                  _buildOrderRow(
                    'Total', 
                    _couponApplied ? '₹2,499' : '₹3,499', 
                    isBold: true
                  ),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        '20% off',
                        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
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
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Text(
                        _couponApplied ? '₹2,499' : '₹3,499',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        ' per month',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Subscribe Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (
                        
                      ) {
                         Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransformationSupportScreen(
                        
                      ),
                    ),);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Subscribe Now',
                        style: TextStyle(
                          fontSize: 14,
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

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: const TextStyle(
           color:  Color(0xFF3C8F7C),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
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
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              if (hasInfo) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _showTaxesModal,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Colors.grey,
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
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
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
                  color: Colors.grey[300],
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
            const SizedBox(height: 8),
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
              color: Colors.black,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}