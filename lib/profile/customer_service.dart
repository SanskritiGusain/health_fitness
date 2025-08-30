import 'package:flutter/material.dart';
import 'package:test_app/utils/custom_app_bars.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you can send data to server or API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form submitted successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive calculations based on Redmi 9A (720x1600)
    // Scale factors for different screen sizes
    final widthScale = screenWidth / 720.0;
    final heightScale = screenHeight / 1600.0;
    final scale = (widthScale + heightScale) / 2;

    // Responsive dimensions
    final horizontalPadding = screenWidth * 0.044; // ~16px on 360dp width
    final verticalPadding = screenHeight * 0.016; // ~26px on 1600px height
    final titleFontSize = (20 * scale).clamp(22.0, 28.0);
    final buttonHeight = (48 * scale).clamp(44.0, 56.0);
    final buttonFontSize = (18 * scale).clamp(18.0, 24.0);
    final fieldSpacing = (24 * scale).clamp(26.0, 36.0);
    final titleSpacing = (26 * scale).clamp(30.0, 42.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFD),
      appBar: CustomAppBars.backAppBar(context, "Get in Touch"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: horizontalPadding,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Drop us a line",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: titleFontSize,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: titleSpacing),

                          // Name Field
                          _buildTextFormField(
                            controller: _nameController,
                            hintText: "Name",
                            scale: scale,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your name";
                              } else if (!RegExp(
                                r'^[a-zA-Z\s]+$',
                              ).hasMatch(value)) {
                                return "Name should contain only letters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldSpacing),

                          // Email Field
                          _buildTextFormField(
                            controller: _emailController,
                            hintText: "Email",
                            scale: scale,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your email";
                              } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                              ).hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldSpacing),

                          // Phone Field
                          _buildTextFormField(
                            controller: _phoneController,
                            hintText: "Phone Number",
                            scale: scale,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter phone number";
                              } else if (!RegExp(
                                r'^[0-9]{10,15}$',
                              ).hasMatch(value)) {
                                return "Enter valid phone number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: fieldSpacing),

                          // Message Field
                          _buildTextFormField(
                            controller: _messageController,
                            hintText: "Message",
                            scale: scale,
                            maxLines: (40 * scale).clamp(4, 6).round(),
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? "Enter your message"
                                        : null,
                          ),

                          // Flexible spacer that adapts to content
                          const Spacer(),

                          // Minimum spacing before button
                          SizedBox(height: fieldSpacing),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12 * scale,
                                  ),
                                ),
                                elevation: 2,
                              ),
                              onPressed: _submitForm,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),

                          // Bottom padding for safe area
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 16,
                          ),
                        ],
                      ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required double scale,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final fontSize = (18 * scale).clamp(16.0, 22.0); // Increased font size
    final borderRadius = (8 * scale).clamp(6.0, 16.0);
    final contentPadding = EdgeInsets.symmetric(
      horizontal: (16 * scale).clamp(
        14.0,
        20.0,
      ), // Increased horizontal padding
      vertical: (20 * scale).clamp(
        14.0,
        24.0,
      ), // Increased vertical padding for height
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
