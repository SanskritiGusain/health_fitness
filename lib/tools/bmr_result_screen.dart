import 'package:flutter/material.dart';
import 'package:test_app/utils/tool_curve_card.dart';

class BmrResultScreen extends StatelessWidget {
  final int bmr;

  const BmrResultScreen({super.key, required this.bmr});

  Map<String, dynamic> _getCategory(int value) {
    if (value < 1200) {
      return {"label": "Low", "color": Colors.red};
    } else if (value < 2000) {
      return {"label": "Medium", "color": Colors.orange};
    } else {
      return {"label": "High", "color": Colors.green};
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _getCategory(bmr);

    // ✅ Responsive scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double fontScale = screenWidth / 375;
    final double paddingScale = screenWidth / 400;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB),
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          "BMR",
          style: TextStyle(
            fontSize: 16 * fontScale,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),

        // ✅ Divider moved here
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02), // ✅ spacing below appbar

          // ✅ CustomCard
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2 * paddingScale),
            child: CustomCard(
              percentage: "$bmr",
              unit: "Kcal/day",
              label: category["label"],
              valueColor: category["color"],
              curveSvg: "assets/icons_update/curve.png",
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * paddingScale),
            child: Text(
              "BMR (Basal Metabolic Rate) is the number of calories your body needs to perform basic functions like breathing and digestion while at rest. It’s the foundation for determining your daily calorie needs.",
              style: TextStyle(
                fontSize: 12 * fontScale,
                color: const Color(0xFF767780),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
