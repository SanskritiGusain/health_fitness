import 'dart:math';
import 'package:flutter/material.dart';

class BMIGaugePainter extends CustomPainter {
  final double bmi;
  BMIGaugePainter(this.bmi);

  final List<Color> colors = [
    Color(0xFF52C9F7), // Underweight
    Color(0xFF97CD17), // Normal
    Color(0xFFFEDA00), // Overweight
    Color(0xFFF8931F), // Obese
    Color(0xFFFE0000), // Extremely Obese
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
    final center = Offset(size.width / 2, size.height * 0.75); // Better vertical positioning
    final radius = size.width * 0.4; // More proportional radius
    final sweepPerRange = pi / (bmiRanges.length - 1);
    final startAngle = -pi;

    // Outer dark blue border
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 40),
      pi,
      pi,
      false,
      Paint()
        ..color = Color(0xFF003176)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Light grey background stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 25),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25,
    );

    // Inner grey stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 75),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Colored ranges with improved positioning
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 85;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 30),
        startAngle + i * sweepPerRange,
        sweepPerRange,
        false,
        paint,
      );
    }

    // Top grey stroke
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 15),
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Category labels with better spacing
    for (int i = 0; i < categories.length; i++) {
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(
        canvas, 
        categories[i], 
        center, 
        radius + 28,
        sectionStart, 
        sectionEnd,
        fontSize: 10, 
        color: Color(0xFF6B6B6B), 
        fontWeight: FontWeight.w600
      );
    }

    // BMI range labels with better positioning
    for (int i = 0; i < labels.length; i++) {
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(
        canvas, 
        labels[i], 
        center, 
        radius - 25, 
        sectionStart,
        sectionEnd,
        fontSize: 10,
        color: Colors.white,
        fontWeight: FontWeight.bold
      );
    }

    // Needle with improved positioning
    final angle = _getNeedleAngle(bmi);
    _drawNeedle(canvas, center, angle, radius - 50);
  }

  void _drawNeedle(Canvas canvas, Offset center, double angle, double length) {
    final needleWidth = 10; // Slightly thinner needle
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
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2));

    // Needle fill with improved gradient
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF1A1A1A),
              Color(0xFF000000)
            ], 
            stops: [0.0, 0.5, 1.0]
          ).createShader(Rect.fromPoints(baseLeft, tip)));

    // Center hub
    const hubRadius = 12.0;
    
    // Hub shadow
    canvas.drawCircle(
        Offset(center.dx + 1, center.dy + 1),
        hubRadius,
        Paint()..color = Colors.black26);

    // Main hub
    canvas.drawCircle(
        center,
        hubRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF0F0F0F),
            ]
          ).createShader(Rect.fromCircle(center: center, radius: hubRadius)));

    // Hub border
    canvas.drawCircle(
        center,
        hubRadius,
        Paint()
          ..color = Color(0xFF1C1C1C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // Inner hub highlight
    canvas.drawCircle(
        center,
        hubRadius * 0.6,
        Paint()
          ..color = Color(0xFF505050)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8);
  }

  double _getNeedleAngle(double bmi) {
    // Clamp BMI to the min and max range
    final clampedBmi = bmi.clamp(bmiRanges.first, bmiRanges.last);

    // Map BMI to 0.0 - 1.0 over the whole range
    final percent = (clampedBmi - bmiRanges.first) /
        (bmiRanges.last - bmiRanges.first);

    // Start angle = pi (left), sweep 180° (pi)
    final startAngle = pi;
    final endAngle = 2 * pi;
    final angle = startAngle + percent * (endAngle - startAngle);

    return angle;
  }

  void _drawCircularText(Canvas canvas, String text, Offset center,
      double radius, double start, double end,
      {double fontSize = 12,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    final sweep = end - start;
    
    // Better character spacing calculation
    final totalChars = text.length;
    final availableAngle = sweep * 0.8; // Use 80% of available space
    final charSpacing = availableAngle / (totalChars + 1);
    final startOffset = (sweep - availableAngle) / 2;

    for (int i = 0; i < totalChars; i++) {
      final char = text[i];
      final angle = start + startOffset + (i + 1) * charSpacing;
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
                fontSize: fontSize, 
                color: color, 
                fontWeight: fontWeight,
                fontFamily: 'Roboto' // Better font consistency
            )),
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