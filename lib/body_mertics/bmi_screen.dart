import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_app/pages/success_page.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const BMIScreen(bmi: 22.5),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMIGaugePainter extends CustomPainter {
  final double bmi;
  BMIGaugePainter(this.bmi);

  final List<Color> colors = [
    const Color(0xFF52C9F7), // Underweight
    const Color(0xFF97CD17), // Normal
    const Color(0xFFFEDA00), // Overweight
    const Color(0xFFF8931F), // Obese
    const Color(0xFFFE0000), // Extremely Obese
  ];

  final List<double> bmiRanges = [0, 18.5, 24.9, 29.9, 34.9, 40];

  final List<String> labels = ["<18.5", "18.5-24.9", "25-29.9", "30-34.9", ">35"];

  final List<String> categories = [
    "UNDERWEIGHT",
    "NORMAL",
    "OVERWEIGHT",
    "OBESE",
    "EXTREMELY OBESE"
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 1.2);
    final radius = size.width / 2.2;
    final sweepPerRange = pi / (bmiRanges.length - 1);
    final startAngle = -pi;

    // Outer dark blue border
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

    // Light grey background stroke
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

    // Colored ranges
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 105;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
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

    // Category labels
    for (int i = 0; i < categories.length; i++) {
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(canvas, categories[i], center, radius + 30,
          sectionStart, sectionEnd,
          fontSize: 12, color: const Color(0xFF6B6B6B), fontWeight: FontWeight.w700);
    }

    // BMI range labels
    for (int i = 0; i < labels.length; i++) {
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(canvas, labels[i], center, radius - 30, sectionStart,
          sectionEnd,
          fontSize: 12,
          color: const Color(0xFFF8FBFB),
          fontWeight: FontWeight.bold);
    }

    // Needle
    final angle = _getNeedleAngle(bmi);
    _drawNeedle(canvas, center, angle, radius - 60);
  }

  void _drawNeedle(Canvas canvas, Offset center, double angle, double length) {
    const needleWidth = 13;
    final tip = Offset(center.dx + length * cos(angle),
        center.dy + length * sin(angle));
    final baseLeft = Offset(center.dx + needleWidth * cos(angle + pi / 2),
        center.dy + needleWidth * sin(angle + pi / 2));
    final baseRight = Offset(center.dx + needleWidth * cos(angle - pi / 2),
        center.dy + needleWidth * sin(angle - pi / 2));

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
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));

    // Needle fill
    canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(colors: [
            Color(0xFF111111),
            Color(0xFF0E0E0E),
            Color(0xFF000000)
          ], stops: [
            0.0,
            0.5,
            1.0
          ]).createShader(Rect.fromPoints(baseLeft, tip)));

    // Center hub
    const hubRadius = 12.0;
    canvas.drawCircle(
        Offset(center.dx + 1, center.dy + 1),
        hubRadius,
        Paint()
          ..color = Colors.black26);

    canvas.drawCircle(
        center,
        hubRadius,
        Paint()
          ..shader = const RadialGradient(colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ]).createShader(Rect.fromCircle(center: center, radius: hubRadius)));

    canvas.drawCircle(
        center,
        hubRadius,
        Paint()
          ..color = const Color(0xFF0B0B0B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    canvas.drawCircle(
        center,
        hubRadius * 0.6,
        Paint()
          ..color = const Color(0xFF6A6A6A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  double _getNeedleAngle(double bmi) {
    int index = 0;
    for (int i = 0; i < bmiRanges.length - 1; i++) {
      if (bmi >= bmiRanges[i] && bmi < bmiRanges[i + 1]) {
        index = i;
        break;
      }
    }
    if (bmi >= bmiRanges.last) index = bmiRanges.length - 2;

    double rangeStart = bmiRanges[index];
    double rangeEnd = bmiRanges[index + 1];
    double percent = (bmi - rangeStart) / (rangeEnd - rangeStart);
    final sweepPerRange = pi / (bmiRanges.length - 1);
    final startAngle = -pi;
    const needleOffset = -0.2;

    return startAngle + (index + percent) * sweepPerRange + needleOffset;
  }

  void _drawCircularText(Canvas canvas, String text, Offset center,
      double radius, double start, double end,
      {double fontSize = 12,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    final sweep = end - start;
    final spacing = sweep / (text.length + 1);

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final angle = start + (i + 1) * spacing;
      final pos = Offset(center.dx + radius * cos(angle),
          center.dy + radius * sin(angle));
      _drawRotatedText(canvas, char, pos, angle + pi / 2,
          fontSize: fontSize, color: color, fontWeight: fontWeight);
    }
  }

  void _drawRotatedText(Canvas canvas, String text, Offset offset, double angle,
      {double fontSize = 12,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    final textPainter = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontSize: fontSize, color: color, fontWeight: fontWeight)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout();

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) =>
      oldDelegate.bmi != bmi;
}

class BMIScreen extends StatefulWidget {
  final double bmi;

  const BMIScreen({super.key, required this.bmi});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController _heightController =
      TextEditingController(text: "170");
  final TextEditingController _weightController =
      TextEditingController(text: "70");

  double _height = 170; // in cm
  double _weight = 70; // in kg
  double _targetWeight = 65; // Target weight

  // Progress tracking - you can adjust these values based on your app's flow
  int currentStep = 3; // Current step (e.g., BMI calculation step)
  int totalSteps = 5; // Total steps in your onboarding/setup flow

  double get _bmi => _weight / ((_height / 100) * (_height / 100));
  double get _targetBMI => _targetWeight / ((_height / 100) * (_height / 100));

  @override
  Widget build(BuildContext context) {
    final categoryMessage = _getBMICategoryMessage(_bmi);
    final categoryColor = _getCategoryColor(_bmi);
    final currentBMI = _bmi;
    
    // Screen dimensions
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
          icon: const Icon(Icons.arrow_back, color: Colors.black,size:26),
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
                    widthFactor: currentStep / totalSteps,
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
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

                          // BMI Gauge
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
                                CustomPaint(
                                  size: Size(
                                    isTablet ? 350 : (isSmallScreen ? 250 : 285),
                                    isTablet ? 200 : (isSmallScreen ? 130 : 160),
                                  ),
                                  painter: BMIGaugePainter(currentBMI),
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
                                  currentBMI.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: isTablet ? 28 : (isSmallScreen ? 18 : 20),
                                    fontWeight: FontWeight.w700,
                                    color: categoryColor,
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
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Dynamic Weight Card
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF7F7F7F),
                                      ),
                                      children: [
                                        const TextSpan(text: "Your ideal weight should be in "),
                                        TextSpan(
                                          text: "${_getMinWeight()}",
                                          style: const TextStyle(color: Color(0xFF97CD17)),
                                        ),
                                        const TextSpan(text: " to "),
                                        TextSpan(
                                          text: "${_targetWeight.toInt()}",
                                          style: const TextStyle(color: Color(0xFF97CD17)),
                                        ),
                                        const TextSpan(text: " kg"),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.015),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_targetWeight > 40) _targetWeight -= 1;
                                        });
                                      },
                                      child: Container(
                                        width: isSmallScreen ? 20 : 24,
                                        height: isSmallScreen ? 20 : 24,
                                        decoration: BoxDecoration(
                                         color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: isSmallScreen ? 14 : 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.05),
                                    Text(
                                      "${_targetWeight.toInt()}kg",
                                      style: TextStyle(
                                        fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                                        fontWeight: FontWeight.w700,
                                        color: _getTargetWeightColor(),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.05),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_targetWeight < 120) _targetWeight += 1;
                                        });
                                      },
                                      child: Container(
                                        width: isSmallScreen ? 20 : 24,
                                        height: isSmallScreen ? 20 : 24,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: isSmallScreen ? 14 : 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: screenHeight * 0.015),
                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: _getTargetWeightMessageWidget(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // CTA Button
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SuccessPage()),
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

  // Reusable Input Widget
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w600,
            color: Color(0xFF7F7F7F),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF97CD17), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  String _getIdealWeightRange() {
    // Calculate ideal weight range based on BMI 18.5-24.9
    final heightInM = _height / 100;
    final minWeight = (18.5 * heightInM * heightInM).round();
    final maxWeight = (24.9 * heightInM * heightInM).round();
    return "${minWeight} to ${minWeight}";
  }
  
  int _getMinWeight() {
    final heightInM = _height / 100;
    return (18.5 * heightInM * heightInM).round();
  }

  String _getWeightRangeText() {
    final idealRange = _getIdealWeightRange();
    
    if (_bmi < 18.5) {
      return "Your ideal weight should be in $idealRange";
    } else if (_bmi >= 18.5 && _bmi <= 24.9) {
      return "Your ideal weight should be in $idealRange";
    } else if (_bmi >= 25 && _bmi < 30) {
      return "Your ideal weight should be in $idealRange";
    } else if (_bmi >= 30 && _bmi < 35) {
      return "Your ideal weight should be in $idealRange";
    } else {
      return "Your ideal weight should be in $idealRange";
    }
  }

  Color _getTargetWeightColor() {
    if (_targetBMI >= 18.5 && _targetBMI <= 24.9) {
      return const Color(0xFF97CD17); // Green for ideal range
    } else if (_targetBMI < 18.5) {
      return const Color(0xFFE74C3C); // Red for too low
    } else if (_targetBMI < 30) {
      return const Color(0xFFF39C12); // Orange for overweight
    } else {
      return const Color(0xFFE74C3C); // Red for obese
    }
  }

  Widget _getTargetWeightMessageWidget() {
    final targetBMI = _targetBMI;
    final weightText = "${_targetWeight.toInt()}kg";
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    
    if (targetBMI >= 18.5 && targetBMI <= 24.9) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
            color: const Color(0xFF7F7F7F),
            fontWeight: FontWeight.w500,
          ),
          children: [
            const TextSpan(text: "Your target weight is set to "),
            TextSpan(
              text: weightText,
              style: const TextStyle(
                color: Color(0xFF0C0C0C),
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ".\nYou're aiming lean stay consistent and you'll hit it strong and healthy."),
          ],
        ),
      );
    } else if (targetBMI < 18.5) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
            color: const Color(0xFF7F7F7F),
          ),
          children: [
            const TextSpan(text: "Your target weight is set to "),
            TextSpan(
              text: weightText,
              style: const TextStyle(color: Color(0xFF0C0C0C)),
            ),
            const TextSpan(text: ".\nYour goal seems a bit unrealistic. Let's aim for a healthier target"),
          ],
        ),
      );
    } else if (targetBMI >= 25 && targetBMI < 30) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
            color: const Color(0xFF7F7F7F),
          ),
          children: [
            const TextSpan(text: "Your target weight is set to "),
            TextSpan(
              text: weightText,
              style: const TextStyle(color: Colors.black),
            ),
            const TextSpan(text: ".\nGood Effort, once you reach here, we'll guide you further if you choose to reduce more"),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: isTablet ? 14 : (isSmallScreen ? 10 : 12),
            color: const Color(0xFF7F7F7F),
          ),
          children: [
            const TextSpan(text: "Your target weight is set to "),
            TextSpan(
              text: weightText,
              style: const TextStyle(color: Colors.black),
            ),
            const TextSpan(text: ".\nYour goal seems a bit unrealistic. Let's aim for a\nhealthier target"),
          ],
        ),
      );
    }
  }

  String _getBMICategoryMessage(double bmi) {
    if (bmi < 18.5) return "You're in the underweight range";
    if (bmi < 25) return "You're in the normal range";
    if (bmi < 30) return "You're in the overweight range";
    if (bmi < 35) return "You're in the obese range";
    return "You're in the extremely obese range";
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    if (bmi < 35) return "Obese";
    return "Extremely Obese";
  }

  Color _getCategoryColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF52C9F7);
    if (bmi < 25) return const Color(0xFF97CD17);
    if (bmi < 30) return const Color(0xFFFEDA00);
    if (bmi < 35) return const Color(0xFFF8931F);
    return const Color(0xFFFE0000);
  }
}