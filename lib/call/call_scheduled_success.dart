import 'package:flutter/material.dart';
import 'package:test_app/plan/plan_screen.dart';
import 'package:test_app/plan/workout_completion.dart';

class CallScheduledSuccessScreen extends StatelessWidget {
  const CallScheduledSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;
    
    // Responsive dimensions
    final horizontalMargin = _getHorizontalMargin(screenWidth);
    final cardPadding = _getCardPadding(screenWidth);
    final iconSize = _getIconSize(screenWidth);
    final titleFontSize = _getTitleFontSize(screenWidth);
    final descriptionFontSize = _getDescriptionFontSize(screenWidth);
    final buttonVerticalPadding = _getButtonPadding(screenWidth);
    final maxCardWidth = isLargeScreen ? 500.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Container(
                    width: maxCardWidth,
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: screenHeight * 0.05, // 5% of screen height
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: cardPadding,
                      vertical: cardPadding * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: isTablet ? 16 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Tick icon with responsive sizing
                        Image.asset(
                          'assets/icons/tick_icon.png',
                          height: iconSize,
                          width: iconSize,
                        ),
                        SizedBox(height: screenHeight * 0.025), // Increased spacing

                        // ✅ Title with responsive font size
                        Text(
                          'Call Scheduled Successfully',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D9479),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.025), // Increased spacing

                        // ✅ Description with responsive font size
                        Text(
                          'Your callback request has been received. Our expert will contact you within the next 48 hours. Stay tuned!',
                          style: TextStyle(
                            fontSize: descriptionFontSize,
                            color: const Color(0xFF222326),
                            height: 1.5, // Increased line height
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.05), // Increased spacing

                        // ✅ Go to Home Button with responsive sizing
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final exercises = [
                                WorkoutExercise(
                                  name: 'Squats',
                                  details: '3 sets × 15 reps',
                                  category: 'Strength',
                                ),
                                WorkoutExercise(
                                  name: 'Cycling',
                                  details: '1 hour', 
                                  category: 'Cardio',
                                ),
                                WorkoutExercise(
                                  name: 'Standing Forward Bend',
                                  details: '1 hour',
                                  category: 'Flexibility',
                                ),
                              ];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlanScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C0C0C),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Go to Home',
                                  style: TextStyle(
                                    fontSize: _getButtonFontSize(screenWidth), // Dedicated button font size
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12), // Increased spacing
                                Icon(
                                  Icons.arrow_forward_ios, 
                                  size: isTablet ? 22 : 20, // Larger icon
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper methods for responsive sizing
  double _getHorizontalMargin(double screenWidth) {
    if (screenWidth > 900) return screenWidth * 0.15; // 15% margin on large screens
    if (screenWidth > 600) return screenWidth * 0.1;  // 10% margin on tablets
    return screenWidth * 0.06; // 6% margin on phones
  }

  double _getCardPadding(double screenWidth) {
    if (screenWidth > 900) return 40.0; // Increased padding
    if (screenWidth > 600) return 36.0; // Increased padding
    return 28.0; // Increased padding
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth > 900) return 80.0; // Larger icon
    if (screenWidth > 600) return 70.0; // Larger icon
    return 60.0; // Larger icon
  }

  double _getTitleFontSize(double screenWidth) {
    if (screenWidth > 900) return 28.0; // Larger title
    if (screenWidth > 600) return 26.0; // Larger title
    return 22.0; // Larger title
  }

  double _getDescriptionFontSize(double screenWidth) {
    if (screenWidth > 900) return 18.0; // Larger description
    if (screenWidth > 600) return 16.0; // Larger description
    return 14.0; // Larger description
  }

  double _getButtonPadding(double screenWidth) {
    if (screenWidth > 900) return 22.0; // Larger button
    if (screenWidth > 600) return 20.0; // Larger button
    return 18.0; // Larger button
  }

  double _getButtonFontSize(double screenWidth) {
    if (screenWidth > 900) return 20.0; // Larger button text
    if (screenWidth > 600) return 18.0; // Larger button text
    return 16.0; // Larger button text
  }
}