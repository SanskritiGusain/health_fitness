import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:test_app/utils/custom_date_picker.dart';
import 'package:test_app/utils/custom_curve.dart';

class WaterIntakeScreen extends StatefulWidget {
  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  double consumed = 0.0; // Start with 0 consumed
  final double goal = 5.0; // Changed to 5L goal

  void increase() {
    if (consumed < goal) {
      setState(() {
        consumed += 1.0; // User drinks 1L
      });
    }
  }

  void decrease() {
    if (consumed > 0.0) {
      setState(() {
        consumed -= 1.0; // User removes 1L (undo drinking)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = consumed / goal;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Water",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Water Intake",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // TOP CARD
            // TOP CARD with curve
            Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  // 🎨 Custom Curve in right corner
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomPaint(
                        painter: CustomCurvePainter(color: Colors.blue.shade50),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Image.asset(
                      "assets/icons/water_drop.png",
                      height: 60,
                    ),
                  ),
                  // 📝 Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Daily Goal:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 133, 129, 129),
                                    ),
                                  ),
                                  Text(
                                    "${goal.toInt()}Lt",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Consumed:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 133, 129, 129),
                                    ),
                                  ),
                                  Text(
                                    "${consumed.toInt()}Lt",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Log Water",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 50),

            // BOTTLES (no Expanded, so it won’t stretch)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => _buildBottle(index)),
            ),

            const SizedBox(height: 60), // smaller gap than before
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrease,
                  icon: const Icon(Icons.remove),
                  iconSize: 32,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fixedSize: const Size(48, 48),
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  "${consumed.toInt()}L",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: increase,
                  icon: const Icon(Icons.add),
                  iconSize: 32,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fixedSize: const Size(48, 48),
                  ),
                ),
              ],
            ),

            const Spacer(), // pushes info text to bottom

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Color.fromARGB(255, 122, 121, 121),
                ),
                SizedBox(width: 4),
                Text(
                  "Daily water intake goals recommended by WHO",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 124, 123, 123),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBottle(int index) {
    // Example: each bottle = 1 liter
    if (index < consumed) {
      return Image.asset(
        "assets/images/empty_bottle.png", // already drunk
        height: 200,
      );
    } else {
      return Image.asset(
        "assets/images/fill_bottle.png", // not yet drunk
        height: 200,
      );
    }
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _shadowBox(),
      child: Icon(icon, size: 16, color: Colors.black),
    );
  }

  BoxDecoration _shadowBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
}
