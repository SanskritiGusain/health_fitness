import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String percentage;
  final String label;
  final Color valueColor;
  final String curveSvg;
  final String? unit;

  const CustomCard({
    super.key,
    required this.percentage,
    required this.label,
    required this.valueColor,
    required this.curveSvg,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Scale factors
    final cardHeight = screenHeight * 0.18; // ~18% of screen height
    final imageSize = screenWidth * 0.25; // 25% of screen width
    final percentageFontSize = screenWidth * 0.035; // scales with width
    final unitFontSize = screenWidth * 0.035;

    final labelFontSize = screenWidth * 0.025;

    return Container(
      margin: EdgeInsets.all(screenWidth * 0.04), // responsive margin
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ✅ Background image positioned
          Positioned(
            top: 0,
            right: 0,
            bottom: screenHeight * 0.015,
            child: Image.asset(
              curveSvg,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: percentageFontSize,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),

                if (unit != null) ...[
                 
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: unitFontSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF767780),
                    ),
                  ),
                ],

                SizedBox(height: screenHeight * 0.002),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w500,
                   color: const Color(0xFF767780), // ✅ same color as percentage
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
