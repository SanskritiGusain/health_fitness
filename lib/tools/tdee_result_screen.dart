import 'package:flutter/material.dart';
import 'package:test_app/utils/tool_curve_card.dart'; // Import the CustomCard

class TdeeResultScreen extends StatelessWidget {
  final double tdee;

  const TdeeResultScreen({super.key, required this.tdee});

  // Determine category and color
  Map<String, dynamic> getTdeeCategory(double tdee) {
    String category;
    Color color;
    
    if (tdee < 1800) {
      category = 'Low';
      color = Colors.blue;
    } else if (tdee >= 1800 && tdee <= 2500) {
      category = 'Medium';
      color = Colors.green;
    } else {
      category = 'High';
      color = Colors.red;
    }
    
    return {'category': category, 'color': color};
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = getTdeeCategory(tdee);
    final String category = categoryData['category'] as String;
    final Color categoryColor = categoryData['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        toolbarHeight: 80,
        title: const Text(
          "TDEE",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF000000)),
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
          
          // ✅ Using CustomCard same as Body Fat result screen
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCard(
              percentage: "${tdee.toStringAsFixed(0)}",
              unit: " Kcal/day", // TDEE value with unit
              label: category, // Low/Medium/High
              valueColor: categoryColor, // Dynamic color based on category
              curveSvg: "assets/icons_update/curve.png", // Same curve SVG
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