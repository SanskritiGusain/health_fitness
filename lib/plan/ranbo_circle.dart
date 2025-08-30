import 'package:flutter/material.dart';
import 'dart:math';

class RainbowProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0
  final double size; // circle size

  const RainbowProgressBar({
    super.key,
    required this.progress,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RainbowPainter(progress),
    );
  }
}

class RainbowPainter extends CustomPainter {
  final double progress;
  RainbowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12;
    double radius = (size.width / 2) - strokeWidth;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Rainbow gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 2 * pi,
      colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.red, // close loop
      ],
    );

    // Grey background circle
    final backgroundPaint =
        Paint()
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
