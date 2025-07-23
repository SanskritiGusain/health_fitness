import 'package:flutter/material.dart';

class TdeeResultScreen extends StatelessWidget {
  final double tdee;

  const TdeeResultScreen({super.key, required this.tdee});

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
          "TDEE",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF000000)),
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
                    tdee.toStringAsFixed(0), // rounded to whole number
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A6EBB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kcal/day',
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
              "TDEE (Total Daily Energy Expenditure) is the number of calories your body burns per day based on your activity level.",
              style: TextStyle(fontSize: 12, color: Color(0xFF767780), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
