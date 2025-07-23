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
    final center = Offset(size.width / 2, size.height / 6.15);
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
        ..color = Color(0xFF003176)
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
          fontSize: 12, color: Color(0xFF6B6B6B), fontWeight: FontWeight.w700);
    }

    // BMI range labels
    for (int i = 0; i < labels.length; i++) {
      final sectionStart = startAngle + i * sweepPerRange;
      final sectionEnd = startAngle + (i + 1) * sweepPerRange;
      _drawCircularText(canvas, labels[i], center, radius - 30, sectionStart,
          sectionEnd,
          fontSize: 12,
          color: Color(0xFFF8FBFB),
          fontWeight: FontWeight.bold);
    }

    // Needle
    final angle = _getNeedleAngle(bmi);
    _drawNeedle(canvas, center, angle, radius - 60);
  }

  void _drawNeedle(Canvas canvas, Offset center, double angle, double length) {
    final needleWidth = 13;
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

    // Needle fill
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(colors: [
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
          ..shader = RadialGradient(colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ]).createShader(Rect.fromCircle(center: center, radius: hubRadius)));

    canvas.drawCircle(
        center,
        hubRadius,
        Paint()
          ..color = Color(0xFF0B0B0B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    canvas.drawCircle(
        center,
        hubRadius * 0.6,
        Paint()
          ..color = Color(0xFF6A6A6A)
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
