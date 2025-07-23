import 'package:flutter/animation.dart';
import 'dart:math';

class SpringCurve extends Curve {
  final double stiffness;
  final double damping;

  const SpringCurve({required this.stiffness, required this.damping});

  @override
  double transform(double t) {
    // Simulated spring equation (simplified approximation)
    const double mass = 1.0;
    final double omega = sqrt(stiffness / mass);
    final double zeta = damping / (2 * sqrt(stiffness * mass));
    if (zeta < 1) {
      final double beta = omega * sqrt(1 - zeta * zeta);
      return 1 - exp(-zeta * omega * t) * (cos(beta * t) + (zeta / sqrt(1 - zeta * zeta)) * sin(beta * t));
    } else {
      return t;
    }
  }
}
