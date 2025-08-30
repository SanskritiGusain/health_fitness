import 'package:flutter/material.dart';

class CustomCurvePainter extends CustomPainter {
  final Color color;
  
  CustomCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    var path = Path();
    
    // Start from top-left area
    path.moveTo(size.width * 0.2, size.height * 0.1);
    
    // Create smooth S-curve using cubic bezier
    path.cubicTo(
      size.width * 0.4, size.height * 0.0,    // first control point (pulls up)
      size.width * 0.6, size.height * 0.3,    // second control point (pulls right-down)
      size.width * 0.8, size.height * 0.2,    // end point of first curve
    );
    
    // Continue the S-curve
    path.cubicTo(
      size.width * 1.0, size.height * 0.1,    // first control point (pulls right-up)
      size.width * 1.1, size.height * 0.5,    // second control point (pulls right-down)
      size.width * 0.9, size.height * 0.6,    // end point
    );
    
    // Final curve to complete the S
    path.cubicTo(
      size.width * 0.7, size.height * 0.7,    // first control point
      size.width * 0.5, size.height * 0.9,    // second control point
      size.width * 0.3, size.height * 0.8,    // end point
    );

    canvas.drawPath(path, paint);
    
    // Optional: Draw control points for visualization (remove in production)
    var pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
      
    // Draw small circles at key points
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.1), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.6), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.8), 4, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomCurvePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}