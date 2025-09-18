import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_app/tools/health_connect_toggle.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';

import 'package:test_app/tools/bmi_input.dart';
import 'package:test_app/tools/bmr_input.dart';
import 'package:test_app/tools/body_fat_input.dart';
import 'package:test_app/tools/tdee_input.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        title: const Text(
          'Tools',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222326),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Calculator',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101010),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ToolCard(
                  title: 'BMI',
                  iconPath: 'assets/icons_update/bmi_icon.svg',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BMIScreenInput()),
                  ),
                ),
                ToolCard(
                  title: 'BMR',
                  iconPath: 'assets/icons_update/bmr_icon.svg',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BMRScreenInput()),
                  ),
                ),
                ToolCard(
                  title: 'Body fat',
                  iconPath: 'assets/icons_update/fat_icon.svg',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BodyFatInputPage()),
                  ),
                ),
                ToolCard(
                  title: 'TDEE',
                  iconPath: 'assets/icons_update/tdee_icon.svg',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TDEEScreenInput()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Sync',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ToolCard(
                  title: 'Health Connect',
                  iconPath: 'assets/icons_update/health_connect.svg',
                  isVertical: true,
                  iconSize: 46,
                  onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthConnectToggleScreen()),
                  );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isVertical;
  final double iconSize;
  final VoidCallback? onTap;

  const ToolCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.isVertical = false,
    this.iconSize = 30,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive width: adjusts based on available space
        final cardWidth = (constraints.maxWidth > 400)
            ? (constraints.maxWidth - 12) / 2
            : (MediaQuery.of(context).size.width - 44) / 2;

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: cardWidth,
            height: isVertical ? 120 : 90,
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: isVertical
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          iconPath,
                          width: iconSize,
                          height: iconSize,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D0D0D),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            iconPath,
                            width: iconSize,
                            height: iconSize,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D0D0D),
                              ),
                            ),
                          ),
             

                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}


class CustomCard extends StatelessWidget {
  final String percentage;
  final String label;
  final Color valueColor;
  final String curveImage;

  const CustomCard({
    super.key,
    required this.percentage,
    required this.label,
    required this.valueColor,
    required this.curveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // ✅ Curved Image Positioned
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                curveImage,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ Percentage and Label
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF767780),
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
