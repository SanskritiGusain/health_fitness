import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundedCircularProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final String remainingText;

  const RoundedCircularProgress({
    super.key,
    required this.progress,
    required this.remainingText,
    this.strokeWidth = 12,
    this.progressColor = const Color(0xFF4CAF50),
    this.backgroundColor = const Color(0xFFE6ECF2),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 120),
            painter: _CirclePainter(
              progress: progress,
              strokeWidth: strokeWidth,
              progressColor: progressColor,
              backgroundColor: backgroundColor,
            ),
          ),
          
        ],
      ),
    );
  }
}
class _CirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final double gapSize; // space between arcs in radians

  _CirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    this.gapSize = 0.18, // ≈ 2.3 degrees gap
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth / 2;

    final startAngle = -math.pi / 2; // Start from top
    final sweepProgress = 2 * math.pi * progress;
    final sweepRemaining = 2 * math.pi * (1 - progress);

    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final remainingPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // 🔹 Draw progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepProgress - gapSize,
        false,
        progressPaint,
      );
    }

    // 🔹 Draw remaining arc with gap
    if (progress < 1) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + sweepProgress + gapSize,
        sweepRemaining - 3*gapSize,
        false,
        remainingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}