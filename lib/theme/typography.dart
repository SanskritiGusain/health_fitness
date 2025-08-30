import 'package:flutter/material.dart';

class AppTypography {
  static const TextStyle headlineLarge = TextStyle(
    // Remove extra space here
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    // Remove extra space here
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}
/*import 'package:flutter/material.dart';

class AppTypography {
  static TextStyle headlineLarge(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.05).clamp(18.0, 26.0), // responsive range
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.04).clamp(14.0, 20.0),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.035).clamp(13.0, 18.0),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.032).clamp(12.0, 16.0),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.028).clamp(10.0, 14.0),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.035).clamp(13.0, 18.0),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: (width * 0.032).clamp(12.0, 16.0),
      fontWeight: FontWeight.w600,
    );
  }
}
*/