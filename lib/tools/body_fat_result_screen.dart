import 'package:flutter/material.dart';

class BodyFatResultScreen extends StatelessWidget {
  final double bodyFatPercentage;

  const BodyFatResultScreen({super.key, required this.bodyFatPercentage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        toolbarHeight: 80,
        title: const Text(
          "Body Fat",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "${bodyFatPercentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A6EBB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Body Fat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767780),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "This is your estimated body fat percentage, which represents the amount of fat relative to your total body weight.",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF767780),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
