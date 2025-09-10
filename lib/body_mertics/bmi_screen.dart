import 'package:flutter/material.dart';
import 'package:test_app/api/api_service.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_app/plan/workout_preferences.dart';

// --- API Model Classes ---
class BMICategory {
  final String id;
  final String label;
  final Color color;
  final double bmiMin;
  final double? bmiMax;
  final bool isCurrent;

  BMICategory({
    required this.id,
    required this.label,
    required this.color,
    required this.bmiMin,
    required this.bmiMax,
    required this.isCurrent,
  });

  factory BMICategory.fromJson(Map<String, dynamic> json) {
    final hex = (json["color"] as String).replaceAll("#", "");
    return BMICategory(
      id: json["id"],
      label: json["label"],
      color: Color(int.parse("0xFF$hex")),
      bmiMin: (json["bmi_min"] as num).toDouble(),
      bmiMax: json["bmi_max"] != null ? (json["bmi_max"] as num).toDouble() : null,
      isCurrent: json["is_current"] ?? false,
    );
  }
}
Future<Map<String, dynamic>> fetchUserBMIData() async {
  final response = await ApiService.getRequest("user/");

  // Parse categories list
  List<BMICategory> categories =
      (response["current_bmi_category"] as List)
          .map((json) => BMICategory.fromJson(json))
          .toList();

  return {
    "bmi": (response["current_bmi"] as num).toDouble(),
    "height": (response["current_height"] as num).toDouble(),
    "weight": (response["current_weight"] as num).toDouble(),
    "targetWeight": (response["target_weight"] as num).toDouble(),
    "categories": categories,
  };
}
class PersistentData {
  static const _targetWeightKey = "target_weight";

  static Future<void> saveTargetWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_targetWeightKey, weight);
  }

  static Future<double?> getTargetWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_targetWeightKey);
  }
}
// --- CustomPainter Using Dynamic Data ---
class BMIGaugePainter extends CustomPainter {
  final double bmi;
  final List<BMICategory> categories;

  BMIGaugePainter(this.bmi, this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 1.2);
    final radius = size.width / 2.2;
    final sweepCount = categories.length;
    final sweepPerRange = pi / sweepCount;
    final startAngle = -pi;

    // Draw outer border
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 48),
      pi,
      pi,
      false,
      Paint()
        ..color = const Color(0xFF003176)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Light grey background
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 30),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30,
    );

    // Inner grey stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 89),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Draw dynamic colored ranges and labels
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 105;
    for (int i = 0; i < categories.length; i++) {
      paint.color = categories[i].color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 35),
        startAngle + i * sweepPerRange,
        sweepPerRange,
        false,
        paint,
      );
    }

    // Top grey stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 18),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Draw dynamic labels and BMI ranges
    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(
        canvas,
        cat.label,
        center,
        radius + 28,
        sectionStart,
        sectionEnd,
        fontSize: 12,
        color: const Color(0xFF6B6B6B),
        fontWeight: FontWeight.w700,
      );

      String rangeLabel = (cat.bmiMax != null)
          ? "${cat.bmiMin.toStringAsFixed(1)}-${cat.bmiMax!.toStringAsFixed(1)}"
          : ">${cat.bmiMin.toStringAsFixed(1)}";
      _drawCircularText(
        canvas,
        rangeLabel,
        center,
        radius - 30,
        sectionStart,
        sectionEnd,
        fontSize: 12,
        color: const Color(0xFFF8FBFB),
        fontWeight: FontWeight.bold,
      );
    }

    // Needle calculation
    final angle = _getNeedleAngle(bmi);
    _drawNeedle(canvas, center, angle, radius - 60);
  }

  double _getNeedleAngle(double bmi) {
    int index = 0;
    for (int i = 0; i < categories.length; i++) {
      final min = categories[i].bmiMin;
      final max = categories[i].bmiMax;
      if (max != null && bmi >= min && bmi < max) {
        index = i;
        break;
      } else if (max == null && bmi >= min) {
        index = i;
        break;
      }
    }
    final rangeStart = categories[index].bmiMin;
    final rangeEnd = categories[index].bmiMax ?? (categories[index].bmiMin + 5);
    double percent = (bmi - rangeStart) / (rangeEnd - rangeStart);
    final sweepPerRange = pi / categories.length;
    final startAngle = -pi;
    const needleOffset = -0.2;
    return startAngle + (index + percent) * sweepPerRange + needleOffset;
  }

  void _drawNeedle(Canvas canvas, Offset center, double angle, double length) {
    const needleWidth = 13;
    final tip = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );
    final baseLeft = Offset(
      center.dx + needleWidth * cos(angle + pi / 2),
      center.dy + needleWidth * sin(angle + pi / 2),
    );
    final baseRight = Offset(
      center.dx + needleWidth * cos(angle - pi / 2),
      center.dy + needleWidth * sin(angle - pi / 2),
    );
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();
    // Shadow
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    // Needle fill
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF111111), Color(0xFF0E0E0E), Color(0xFF000000)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromPoints(baseLeft, tip)),
    );
    // Center hub
    const hubRadius = 12.0;
    canvas.drawCircle(
      Offset(center.dx + 1, center.dy + 1),
      hubRadius,
      Paint()..color = Colors.black26,
    );
    canvas.drawCircle(
      center,
      hubRadius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ).createShader(Rect.fromCircle(center: center, radius: hubRadius)),
    );
    canvas.drawCircle(
      center,
      hubRadius,
      Paint()
        ..color = const Color(0xFF0B0B0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      center,
      hubRadius * 0.6,
      Paint()
        ..color = const Color(0xFF6A6A6A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawCircularText(
    Canvas canvas,
    String text,
    Offset center,
    double radius,
    double start,
    double end, {
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final sweep = end - start;
    final spacing = sweep / (text.length + 1);
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final angle = start + (i + 1) * spacing;
      final pos = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      _drawRotatedText(
        canvas,
        char,
        pos,
        angle + pi / 2,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
    }
  }

  void _drawRotatedText(
    Canvas canvas,
    String text,
    Offset offset,
    double angle, {
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) =>
      oldDelegate.bmi != bmi || oldDelegate.categories != categories;
}

// --- Main BMIScreen Widget ---
class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double? bmi;
  double? height;
  double? weight;
  double? targetWeight;
  List<BMICategory> categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserBMI();
  }
// Save & Update Target Weight
  void _updateTargetWeight(int change) async {
    setState(() {
      targetWeight = (targetWeight! + change).clamp(30.0, 200.0); // safe bounds
    });
    await PersistentData.saveTargetWeight(targetWeight!);
  }

  // Dynamic Color Logic
  Color _targetWeightColor(double weight) {
    final idealCat = categories.firstWhere(
      (c) => c.label.toLowerCase().contains("normal"),
      orElse: () => categories[0],
    );
    final minW = idealCat.bmiMin * pow(height! / 100, 2);
    final maxW = idealCat.bmiMax! * pow(height! / 100, 2);

    if (weight >= minW && weight <= maxW) {
      return Colors.green; // ✅ Normal
    } else if ((weight < minW && weight >= minW - 5) ||
        (weight > maxW && weight <= maxW + 5)) {
      return Colors.orange; // ⚠️ Slightly outside
    } else {
      return Colors.red; // ❌ Far outside
    }
  }

  Future<void> _loadUserBMI() async {
    try {
      final data = await fetchUserBMIData();
      setState(() {
        bmi = data["bmi"];
        height = data["height"];
        weight = data["weight"];
        targetWeight = data["targetWeight"];
        categories = data["categories"];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading BMI data: $e");
      setState(() => isLoading = false);
    }
  }

  // --- Helpers (moved here from old Stateless widget) ---
  Color _categoryColor(double bmi) {
    for (var c in categories) {
      final min = c.bmiMin;
      final max = c.bmiMax ?? double.infinity;
      if (bmi >= min && bmi < max) return c.color;
    }
    return Colors.grey;
  }

  BMICategory get currentCategory {
    return categories.lastWhere((c) {
      if (c.bmiMax != null) {
        return bmi! >= c.bmiMin && bmi! < c.bmiMax!;
      } else {
        return bmi! >= c.bmiMin;
      }
    }, orElse: () => categories.first);
  }

  String get categoryMessage {
    return "You're in the ${currentCategory.label} range.";
  }

  String get targetWeightMessage {
    final targetBmi = targetWeight! / ((height! / 100) * (height! / 100));
    final idealCat = categories.firstWhere(
      (c) => c.label.toLowerCase().contains("normal"),
      orElse: () => categories[0],
    );
    if (targetBmi >= idealCat.bmiMin &&
        (idealCat.bmiMax == null || targetBmi <= idealCat.bmiMax!)) {
      return "Your target weight is set to ${targetWeight!.toStringAsFixed(1)}kg.\nYou're aiming lean stay consistent and you'll hit it strong and healthy.";
    } else if (targetBmi < idealCat.bmiMin) {
      return "Your target weight is set to ${targetWeight!.toStringAsFixed(1)}kg.\nYour goal seems a bit unrealistic. Let's aim for a healthier target";
    } else {
      return "Your target weight is set to ${targetWeight!.toStringAsFixed(1)}kg.\nGood effort. If you reach here, we'll guide you further.";
    }
  }

  String get idealWeightRange {
    final idealCat = categories.firstWhere(
      (c) => c.label.toLowerCase().contains("normal"),
      orElse: () => categories[0],
    );
    final minW = (idealCat.bmiMin * pow(height! / 100, 2)).round();
    final maxW =
        idealCat.bmiMax != null
            ? (idealCat.bmiMax! * pow(height! / 100, 2)).round()
            : "-";
    return "$minW to $maxW kg";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (bmi == null || categories.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Failed to load BMI data")),
      );
    }

    // --- your original UI code below ---
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 3 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.12),
                          // --- BMI Gauge ---
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
           child: Column(
  children: [
    if (bmi != null && categories.isNotEmpty) ...[
      CustomPaint(
        size: Size(
          isTablet ? 350 : (isSmallScreen ? 250 : 285),
          isTablet ? 200 : (isSmallScreen ? 130 : 160),
        ),
        painter: BMIGaugePainter(bmi!, categories), // force unwrap
      ),
      SizedBox(height: screenHeight * 0.018),
      Text(
        "Your BMI is",
        style: TextStyle(
          fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: screenHeight * 0.005),
      Text(
        bmi!.toStringAsFixed(1),
        style: TextStyle(
          fontSize: isTablet ? 28 : (isSmallScreen ? 18 : 20),
          fontWeight: FontWeight.w700,
          color: _categoryColor(bmi!), // pass non-null bmi
        ),
      ),
      SizedBox(height: screenHeight * 0.01),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          categoryMessage,
          style: TextStyle(
            fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
            color: const Color(0xFF7F7F7F),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ] else ...[
      const Text("Loading BMI data..."),
    ]
  ],
),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          // --- Dynamic Weight Card ---
          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize:
                                            isTablet
                                                ? 16
                                                : (isSmallScreen ? 12 : 14),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF7F7F7F),
                                      ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              "Your ideal weight should be in ",
                                        ),
                                        TextSpan(
                                          text: idealWeightRange,
                                          style: const TextStyle(
                                            color: Color(0xFF97CD17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),

                                // --- Add & Subtract Buttons ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        size: 32,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () => _updateTargetWeight(-1),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        "${targetWeight!.toStringAsFixed(0)}kg",
                                        style: TextStyle(
                                          fontSize: isTablet ? 20 : 18,
                                          fontWeight: FontWeight.w700,
                                          color: _targetWeightColor(
                                            targetWeight!,
                                          ), // ✅ Dynamic color
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        size: 32,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () => _updateTargetWeight(1),
                                    ),
                                  ],
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                // --- Target Weight Message ---
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    targetWeightMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          isTablet
                                              ? 14
                                              : (isSmallScreen ? 10 : 12),
                                      color: const Color(0xFF7F7F7F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                      // --- CTA Button ---
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.04,
                          bottom: screenHeight * 0.02,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: isSmallScreen ? 44 : 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                   //           PersistentData.saveLastScreen("WorkoutPreferencesPage");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutPreferences(),
                                ),
                              );
                            },
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
