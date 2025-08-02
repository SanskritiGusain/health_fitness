import 'package:flutter/material.dart';
import 'package:test_app/call/call_scheduled_success.dart';

class ScheduleCallScreen extends StatefulWidget {
  @override
  _ScheduleCallScreenState createState() => _ScheduleCallScreenState();
}

class _ScheduleCallScreenState extends State<ScheduleCallScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 9648676342');
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;
    
    // Responsive dimensions
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final maxContentWidth = isLargeScreen ? 600.0 : double.infinity;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      resizeToAvoidBottomInset: false, // Changed to prevent automatic resizing
      body: SafeArea(
        child: Column(
          children: [
            // Responsive App Bar
            _buildAppBar(context, screenWidth, screenHeight, isTablet),
            const Divider(color: Color(0xFFCBD5E1)),

            // Main Content
            Expanded(
              child: Center(
                child: Container(
                  width: maxContentWidth,
                  child: Column(
                    children: [
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            top: _getTopPadding(screenHeight),
                            bottom: 20, // Fixed bottom padding
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Description
                              _buildHeader(screenWidth, isTablet),
                              SizedBox(height: _getVerticalSpacing(screenHeight, 0.04)),

                              // Phone Number Field
                              _buildPhoneNumberField(screenWidth, screenHeight, isTablet),
                              SizedBox(height: _getVerticalSpacing(screenHeight, 0.03)),

                              // Message Field
                              _buildMessageField(screenWidth, screenHeight, isTablet),
                              
                              // Fixed spacing to ensure button area is reserved
                              SizedBox(height: 100), // Reserve space for button
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Fixed bottom button - outside of expanded area
            Container(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: 20,
                top: 10,
              ),
              color: const Color(0xFFF8FBFB),
              child: _buildScheduleButton(context, screenWidth, screenHeight, isTablet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, double screenWidth, double screenHeight, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(screenWidth),
        vertical: _getAppBarVerticalPadding(screenHeight),
      ),
      color: const Color(0xFFF8FBFB),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(isTablet ? 8 : 4),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: _getIconSize(screenWidth),
              ),
            ),
          ),
          SizedBox(width: _getHorizontalSpacing(screenWidth, 0.04)),
          Text(
            'Schedule Call',
            style: TextStyle(
              fontSize: _getTitleFontSize(screenWidth),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222326),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Your Call',
          style: TextStyle(
            fontSize: _getHeaderFontSize(screenWidth),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF222326),
          ),
        ),
        SizedBox(height: _getVerticalSpacing(MediaQuery.of(context).size.height, 0.01)),
        Text(
          'Please provide your details and select your preferred date and time.',
          style: TextStyle(
            fontSize: _getBodyFontSize(screenWidth),
            color: const Color(0xFF525252),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(double screenWidth, double screenHeight, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Phone Number ',
            style: TextStyle(
              fontSize: _getLabelFontSize(screenWidth),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4D5860),
            ),
            children: const [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: _getVerticalSpacing(screenHeight, 0.015)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _phoneController,
            style: TextStyle(
              fontSize: _getInputFontSize(screenWidth),
              color: const Color(0xFF222326),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: _getInputHorizontalPadding(screenWidth),
                vertical: _getInputVerticalPadding(screenHeight),
              ),
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: _getInputFontSize(screenWidth),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(double screenWidth, double screenHeight, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message (Optional)',
          style: TextStyle(
            fontSize: _getLabelFontSize(screenWidth),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4D5860),
          ),
        ),
        SizedBox(height: _getVerticalSpacing(screenHeight, 0.015)),
        Container(
          width: double.infinity,
          height: _getMessageFieldHeight(screenHeight),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              fontSize: _getInputFontSize(screenWidth),
              color: const Color(0xFF222326),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(_getInputHorizontalPadding(screenWidth)),
              hintText: 'Tell us what you\'d like to discuss.',
              hintStyle: TextStyle(
                color: const Color(0xFFC9C9C9),
                fontSize: _getInputFontSize(screenWidth),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleButton(BuildContext context, double screenWidth, double screenHeight, bool isTablet) {
    return Container(
      width: double.infinity,
      height: _getButtonHeight(screenHeight),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScheduledSuccessScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C0C0C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Schedule Call',
          style: TextStyle(
            fontSize: _getButtonFontSize(screenWidth),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Responsive helper methods
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 900) return screenWidth * 0.08;
    if (screenWidth > 600) return screenWidth * 0.06;
    return screenWidth * 0.05;
  }

  double _getTopPadding(double screenHeight) {
    return screenHeight * (screenHeight > 800 ? 0.03 : 0.025);
  }

  double _getAppBarVerticalPadding(double screenHeight) {
    return screenHeight * (screenHeight > 800 ? 0.025 : 0.02);
  }

  double _getVerticalSpacing(double screenHeight, double ratio) {
    return screenHeight * ratio;
  }

  double _getHorizontalSpacing(double screenWidth, double ratio) {
    return screenWidth * ratio;
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth > 900) return 28.0;
    if (screenWidth > 600) return 26.0;
    return 24.0;
  }

  double _getTitleFontSize(double screenWidth) {
    if (screenWidth > 900) return 24.0;
    if (screenWidth > 600) return 22.0;
    return 20.0;
  }

  double _getHeaderFontSize(double screenWidth) {
    if (screenWidth > 900) return 22.0;
    if (screenWidth > 600) return 20.0;
    return 18.0;
  }

  double _getBodyFontSize(double screenWidth) {
    if (screenWidth > 900) return 18.0;
    if (screenWidth > 600) return 16.0;
    return 14.0;
  }

  double _getLabelFontSize(double screenWidth) {
    if (screenWidth > 900) return 18.0;
    if (screenWidth > 600) return 16.0;
    return 14.0;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth > 900) return 18.0;
    if (screenWidth > 600) return 16.0;
    return 14.0;
  }

  double _getButtonFontSize(double screenWidth) {
    if (screenWidth > 900) return 20.0;
    if (screenWidth > 600) return 18.0;
    return 16.0;
  }

  double _getInputHorizontalPadding(double screenWidth) {
    if (screenWidth > 900) return 20.0;
    if (screenWidth > 600) return 18.0;
    return 16.0;
  }

  double _getInputVerticalPadding(double screenHeight) {
    if (screenHeight > 900) return 18.0;
    if (screenHeight > 700) return 16.0;
    return 14.0;
  }

  double _getMessageFieldHeight(double screenHeight) {
    if (screenHeight > 900) return screenHeight * 0.15; // Reduced height
    if (screenHeight > 700) return screenHeight * 0.13;
    return screenHeight * 0.12;
  }

  double _getButtonHeight(double screenHeight) {
    if (screenHeight > 900) return 60.0;
    if (screenHeight > 700) return 56.0;
    return 52.0;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}