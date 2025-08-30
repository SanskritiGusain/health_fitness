// lib/widgets/custom_app_bars.dart
import 'package:flutter/material.dart';

class CustomAppBars {
  /// 🔹 Simple AppBar for pages like "Health Metrics"
  static PreferredSizeWidget simpleAppBar(BuildContext context, String title) {
    final theme = Theme.of(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // scale sizes based on screen size
    final toolbarHeight = screenHeight * 0.09; // ~9% of screen height
    final fontSize = screenWidth * 0.055; // adaptive font size

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      toolbarHeight: toolbarHeight.clamp(56.0, 90.0), // safe min/max
      title: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.01),
        child: Text(
          title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: fontSize.clamp(18, 28).toDouble(), // responsive font size
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: theme.colorScheme.outline, height: 1),
      ),
    );
  }

  /// 🔹 Back AppBar with icon (like "Body Metrics")
  static PreferredSizeWidget backAppBar(BuildContext context, String title) {
    final theme = Theme.of(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final toolbarHeight = screenHeight * 0.010;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      toolbarHeight: toolbarHeight.clamp(56.0, 90.0),
      title: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: screenWidth * 0.045, // responsive back arrow
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: screenWidth * 0.01),
          Text(title, style: theme.textTheme.headlineLarge),
        ],
      ),
    );
  }
}
