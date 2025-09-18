import 'package:flutter/material.dart';
import 'package:test_app/utils/tool_curve_card.dart';

class BodyFatResultScreen extends StatelessWidget {
  final double bodyFatPercentage;
  final String gender;

  const BodyFatResultScreen({
    super.key,
    required this.bodyFatPercentage,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final categoryData = _getBodyFatCategory(bodyFatPercentage, gender);
    final String category = categoryData['category'] as String;
    final Color color = categoryData['color'] as Color;

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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 20),

          // ✅ Fixed CustomCard usage
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCard(
              percentage: "${bodyFatPercentage.toStringAsFixed(1)}%", // show 1 decimal
              label: category,
              valueColor: color,
              curveSvg: "assets/icons_update/curve.png", // use SVG curve
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Body Fat Percentage (BFP) is the proportion of fat in your body compared to everything else (muscles, bones, water, organs). A healthy body fat level is important for energy storage, insulation, and overall health.",
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

  Map<String, dynamic> _getBodyFatCategory(double value, String gender) {
    String category;
    Color color;

    if (gender == 'Male') {
      if (value < 6) {
        category = 'Low';
        color = Colors.blue;
      } else if (value < 24) {
        category = 'Medium';
        color = Colors.green;
      } else {
        category = 'High';
        color = Colors.red;
      }
    } else {
      // Female
      if (value < 14) {
        category = 'Low';
        color = Colors.blue;
      } else if (value < 31) {
        category = 'Medium';
        color = Colors.green;
      } else {
        category = 'High';
        color = Colors.red;
      }
    }

    return {'category': category, 'color': color};
  }
}
