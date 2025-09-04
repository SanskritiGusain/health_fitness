import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/chat/chat_start.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:test_app/pages/weight_input.dart';
import 'package:test_app/plan/diet_tracker.dart';

import 'package:test_app/plan/workout.dart';
import 'package:test_app/shift/nutrition_tracker.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';
// ... other imports ...

class FitnessWellnessScreen extends StatefulWidget {
  const FitnessWellnessScreen({Key? key}) : super(key: key);

  @override
  State<FitnessWellnessScreen> createState() => _FitnessWellnessScreenState();
}

class _FitnessWellnessScreenState extends State<FitnessWellnessScreen> {
  final List<int> kgValues = List.generate(
    171,
    (index) => index + 30,
  ); // 30–200
  final List<int> lbsValues = List.generate(
    271,
    (index) => index + 66,
  ); // 66–336

  late FixedExtentScrollController _controllerKg;
  late FixedExtentScrollController _controllerLbs;
  // State variables
  bool isKg = true;
  int selectedWeightKg = 60;
  int selectedWeightLbs = 132;
  bool _isButtonEnabled = true;
  int selectedDay = DateTime.now().day;
  double currentWeight = 78;
  double goalWeight = 70;
  double initialWeight = 85;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Calculate progress (0.0 to 1.0)
  double get progress =>
      (initialWeight - currentWeight) /
      (initialWeight - goalWeight).clamp(0.1, 1.0);

  // Data maps
  final Map<String, dynamic> fitnessData = {
    'steps': 8543,
    'activeMinutes': 45,
    'caloriesBurned': 420,
  };

  final Map<String, dynamic> nutritionData = {
    'caloriesEaten': 1850,
    'water': 2100,
    'protein': 125,
    'carbs': 240,
  };

  final Map<String, dynamic> sleepData = {
    'sleepHours': 7.5,
    'sleepQuality': 85,
  };
  void _submit() {}
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => selectedImage = File(image.path));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image ${source == ImageSource.camera ? 'captured' : 'uploaded'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

void _showWeightBottomSheet(BuildContext context, double height) {
  final controller = isKg ? _controllerKg : _controllerLbs;
  final values = isKg ? kgValues : lbsValues;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // ... Title, toggle, etc.
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: ListWheelScrollView.useDelegate(
                            controller: controller,
                            itemExtent: 25,
                            diameterRatio: 100,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                if (isKg) {
                                  selectedWeightKg = kgValues[index];
                                } else {
                                  selectedWeightLbs = lbsValues[index];
                                }
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: values.length,
                              builder: (context, index) {
                                final val = values[index];
                                final isLong = val % 5 == 0;
                                return RotatedBox(
                                  quarterTurns: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 60,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 1,
                                            height: isLong ? 60 : 35,
                                            color:
                                                isLong
                                                    ? const Color(0xFF222326)
                                                    : const Color(0xFF9EA3A9),
                                          ),
                                        ),
                                      ),
                                      if (isLong)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            '$val',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 35,
                        bottom: 55,
                        child: Container(
                          width: 2,
                          color: const Color(0xFF0C0C0C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Select Image Source'),
            actions: [
              TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Gallery'),
              ),
              TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text('Camera'),
              ),
            ],
          ),
    );
  }

 Widget _buildPlanCard(String title, String subtitle, String iconPath, BuildContext context, Widget targetScreen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => targetScreen,
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 58, width: 64),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF707070),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 100,
        itemBuilder: (context, index) {
          final day = 1 + index;

          final isSelected = day == selectedDay;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = day),
            child: Container(
              width: 60,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeightTracker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Half circle painter
              SizedBox(
                height: 120, // more than 80
                width: 160,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomPaint(
                    size: const Size(160, 80),
                    painter: RainbowHalfCirclePainter(progress: 0.7),
                  ),
                ),
              ),
              // CustomPaint(
              //   size: const Size(200, 100), // adjust size as needed
              //   painter: RainbowHalfCirclePainter(
              //     progress: 0.7,
              //   ), // 70% progress
              // ),

              // Current weight in the middle
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${currentWeight.toStringAsFixed(0)} kg',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Initial weight (left)
              Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  '${initialWeight.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
              ),

              // Goal weight (right)
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  '${goalWeight.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Weight Goal: ${goalWeight.toStringAsFixed(0)} kg',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),

                OutlinedButton(
                  onPressed: () {
                    _showWeightBottomSheet(context, 170); // pass height
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black, // text color
                    side: const BorderSide(
                      color: Colors.black, // border color
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    backgroundColor: Colors.transparent, // keep transparent
                  ),
                  child: Text(
                    '+ Update Weight',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String value,
    String unit,
    String icon,
  ) {
    // VoidCallback onTap
    return GestureDetector(
      // onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(icon, width: 34, height: 34),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: unit,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(
      initialItem: kgValues.indexOf(selectedWeightKg),
    );
    _controllerLbs = FixedExtentScrollController(
      initialItem: lbsValues.indexOf(selectedWeightLbs),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = isKg ? _controllerKg : _controllerLbs;
    final values = isKg ? kgValues : lbsValues;
    return Scaffold(
      backgroundColor: Color(0xFFF8FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Jane',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                      IconButton(
                        icon: Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      CircleAvatar(radius: 16, child: Icon(Icons.person)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),
              _buildDateSelector(),
              SizedBox(height: 24),
              _buildWeightTracker(),
              SizedBox(height: 24),

              // Today's Plan
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Plan is ready",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPlanCard(
                      'Diet',
                      '2000 kcal target',
                      'assets/icons/diet_icon.png',
                       context,
                     
                     DietScreen()
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildPlanCard(
                      'Workout',
                      '15-30 min session',
                      'assets/icons/fitness_icon.png',
                       context,WorkoutScreen()
                      
                    ),
                  ),
                ],
              ),

              SizedBox(height: 34),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 12),

              // Activity Grid
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildActivityCard(
                    'Calories Consumed',
                    '${nutritionData['caloriesEaten']}',
                    '/2,500',
                    'assets/icons/food.png',
                    // () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => CalorieTrackerScreen()),
                    // )
                  ),
                  _buildActivityCard(
                    'Calories Burned',
                    '${fitnessData['caloriesBurned']}',
                    '/2,500',
                    'assets/icons/calories.png',
                    // () => Navigator.push(context,
                    //   MaterialPageRoute(builder: (_) => StepsScreen()))
                  ),
                  _buildActivityCard(
                    'Steps',
                    '${fitnessData['steps']}',
                    '/20,000',
                    'assets/icons/steps.png',
                    // () => Navigator.push(context,
                    //   MaterialPageRoute(builder: (_) => StepsScreen()))
                  ),
                  _buildActivityCard(
                    'Water',
                    '${nutritionData['water']}',
                    '/6 Lt',
                    'assets/icons/water.png',
                    // () => Navigator.push(context,
                    //   MaterialPageRoute(builder: (_) => WaterIntakeScreen()))
                  ),
                  _buildActivityCard(
                    'Sleep',
                    '${fitnessData['sleep']}',
                    '/4hr',
                    'assets/icons/sleep.png',
                    // () => Navigator.push(context,
                    //   MaterialPageRoute(builder: (_) => StepsScreen()))
                  ),
                ],
              ),

              SizedBox(height: 24),
              // Progress Journey
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress Journey',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: Text('View all images')),
                ],
              ),

              SizedBox(height: 16),
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: 120,
                  height: 142,
                  decoration: BoxDecoration(
                    border:
                        selectedImage == null
                            ? Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                            )
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      selectedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 24),
                              Text('Add photo', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNav(
      //   currentIndex: 0,
      //   onTap: (index) {
      //     // Navigation logic
      //   },
      // ),
       bottomNavigationBar: const CustomNavBar(currentIndex: 0),
             floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 170, 207, 171),
          label: const Text(
            "Ask Luna",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          icon: Image.asset("assets/icons/ai.png", height: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    
    );
  }
}

class RainbowHalfCirclePainter extends CustomPainter {
  final double progress; // 0.0 → 1.0

  RainbowHalfCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1️⃣ Draw background arc (light grey or white)
    final bgPaint =
        Paint()
          ..color = Color(0xFFC9C9C9)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    canvas.drawArc(
      rect,
      math.pi, // start from left
      math.pi, // full half circle
      false,
      bgPaint,
    );

    // 2️⃣ Draw progress arc with rainbow gradient
    final gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: 2 * math.pi,
      colors: const [Colors.red, Colors.orange, Colors.yellow, Colors.green],
    );

    final progressPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    final sweepAngle = math.pi * progress;

    canvas.drawArc(rect, math.pi, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
