import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/plan/step_screen.dart';
import 'package:test_app/plan/calorie_tracker.dart';
import 'package:test_app/shift/checkout_screen.dart';
import 'package:test_app/utils/custom_date_picker.dart'; 
import 'package:test_app/plan/fitness_flow.dart'; 
import 'package:test_app/utils/custom_bottom_nav.dart'; 

import 'package:test_app/call/schedule_call.dart'; 
import 'package:test_app/profile/alert_screen.dart'; 
import 'package:test_app/plan/diet_preferences.dart'; 
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:test_app/pages/home_page.dart'; 
import 'package:test_app/shift/checkout_screen.dart';
import 'package:test_app/chat/chat_screen.dart'; 
import 'package:test_app/gamification/gamification_screen.dart'; 
import 'package:test_app/tools/tools_screen.dart'; 

class FitnessWellnessScreen extends StatefulWidget {
  const FitnessWellnessScreen({Key? key}) : super(key: key);

  @override
  State<FitnessWellnessScreen> createState() => _FitnessWellnessScreenState();
}

class _FitnessWellnessScreenState extends State<FitnessWellnessScreen> {
  int _selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  
  // Track completion status
  bool isFitnessFlowCompleted = false;
  bool isDietPreferencesCompleted = false;
  bool isAlarmsCompleted = false;
  File? selectedImage;
  
  final ImagePicker _picker = ImagePicker();

  String get displayDateText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
    if (selected == today) {
      return "Today";
    } else if (selected == today.subtract(Duration(days: 1))) {
      return "Yesterday";
    } else if (selected == today.add(Duration(days: 1))) {
      return "Tomorrow";
    } else {
      return "${selected.day.toString().padLeft(2, '0')} ${_getMonthName(selected.month)}";
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Calculate completion percentage
  double get completionPercentage {
    int completedTasks = 0;
    if (isFitnessFlowCompleted) completedTasks++;
    if (isDietPreferencesCompleted) completedTasks++;
    if (isAlarmsCompleted) completedTasks++;
    return completedTasks / 3.0;
  }

  String get completionText {
    int percentage = (completionPercentage * 100).round();
    return '$percentage% completed';
  }

  void _navigateToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
  }

  void _navigateToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _navigateToPreviousDay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayDateText, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 21, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _navigateToNextDay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFE8E8E8),
              child: Icon(Icons.person, color: Color(0xFF666666)),
            ),
            const SizedBox(width: 12),
            const Text(
              'Hi, Jane',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/notification.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Date Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildDateSelector(),
            ),
            
            const SizedBox(height: 20),
            
            // Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Let's setup your plan",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 102),
                      Text(
                        completionText,
                        style: TextStyle(
                          fontSize: 12,
                          color: completionPercentage > 0.5 
                              ? Colors.green 
                              : const Color.fromARGB(255, 132, 132, 132),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completionPercentage,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionPercentage > 0.5 
                          ? Colors.green 
                          : const Color.fromARGB(255, 35, 35, 35)
                    ),
                    minHeight: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Get Started Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Setup Items
                  _buildSetupItem(
                    imagePath: 'assets/icons/fitness_icon.png',
                    title: 'Set up your fitness flow',
                    isCompleted: isFitnessFlowCompleted,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FitnessFlowScreen()),
                      );
                      // Assume the screen returns true when completed
                      if (result == true) {
                        setState(() {
                          isFitnessFlowCompleted = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSetupItem(
                    imagePath: 'assets/icons/diet_icon.png',
                    title: 'Set up your dietary preferences',
                    isCompleted: isDietPreferencesCompleted,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DietPreferencesScreen()),
                      );
                      if (result == true) {
                        setState(() {
                          isDietPreferencesCompleted = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSetupItem(
                    imagePath: 'assets/icons/alarm_icon.png',
                    title: 'Set up your alarms',
                    isCompleted: isAlarmsCompleted,
                    onTap: () async {
                      // For demo, mark as completed after navigation
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AlertScreen()),
                      );
                      setState(() {
                        isAlarmsCompleted = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // My Activities Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Activity Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard('Steps', '0', 'steps', 'assets/icons/step_icon.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StepsScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActivityCard('Calories', '0', 'cal', 'assets/icons/calories_icon.png', 
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => CalorieTrackerScreen()),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard('Water', '0', 'ml', 'assets/icons/water_icon.png', 
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FitnessFlowScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActivityCard('Sleep', '0', 'hrs', 'assets/icons/sleep_icon.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FitnessFlowScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Progress Journey Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Progress Journey',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 142,
                      width: 120,
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: [
                                  Image.file(
                                    selectedImage!,
                                    width: 120,
                                    height: 142,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(4),
                              dashPattern: [6, 4],
                              color: Colors.grey,
                              strokeWidth: 1,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add, color: Colors.grey, size: 24),
                                    SizedBox(height: 8),
                                    Text(
                                      'Upload your image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Pro Advice Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromRGBO(240, 247, 230, 1),
                      Color.fromRGBO(230, 240, 250, 1),
                    ],
                    stops: [0.35, 0.45],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Get Pro Advice for a Healthier You',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Our app gives you access to expert advice from professional trainers and nutritionists.',
                            style: TextStyle(
                              color: Color.fromARGB(179, 143, 141, 141),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleCallScreen()) );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Request a Call',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -10,
                            child: Container(
                              width: 95,
                              height: 160,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0),
                                ),
                                color: Color(0xFF518FBF),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: -5,
                            child: ClipRRect(
                              child: Image.asset(
                                'assets/images/plan_bottom.png',
                                width: 188,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
 bottomNavigationBar: CustomBottomNav(
      currentIndex: 0, // 0 for Home
      onTap: (index) {
        if (index == 0) return; // Already on home
        
        switch (index) {
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => HealthDashboardScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWelcomeScreen()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => GamificationScreen()));
            break;
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ToolsScreen()));
            break;
        }
      },
    ),
    );
  }

  Widget _buildSetupItem({
    required String imagePath,
    required String title,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isCompleted 
              ? Border.all(color: Colors.green, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: isCompleted 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 42.59,
              height: 38.62,
              child: Image.asset(imagePath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? Colors.green : Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.chevron_right,
                color: isCompleted ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String value,
    String unit,
    String iconPath, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF767780),
                    ),
                  ),
                  const SizedBox(height: 8),
                  value == '0'
                      ? const Text(
                          'No data',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF222326),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              unit,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}