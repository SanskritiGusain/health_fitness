import 'package:flutter/material.dart';

class BmrScreen extends StatelessWidget {
  final int bmr;

  const BmrScreen({super.key, required this.bmr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        title: const Text(
          "BMR",
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Divider under AppBar
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),

          // BMR Card
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
                    bmr.toString(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A6EBB),
                    ),
                  ),
                  const SizedBox(height: 0),
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

          // Info Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              "BMR (Basal Metabolic Rate) is the number of calories your body needs to perform basic functions like breathing and digestion while at rest. It’s the foundation for determining your daily calorie needs.",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF767780),
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
