import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/api/matrics_service.dart';
import 'package:test_app/chat/chat_start.dart';
import 'package:test_app/new/sleep_tracking.dart';
import 'package:test_app/pages/logout.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:test_app/pages/weight_input.dart';
import 'package:test_app/plan/calorie_tracker.dart';
import 'package:test_app/plan/diet_tracker.dart';
import 'package:test_app/plan/step_screen.dart';
import 'package:test_app/plan/workout.dart';
import 'package:test_app/shift/nutrition_tracker.dart';
import 'package:test_app/shift/water.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';

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

  // Weight variables
  double currentWeight = 0;
  double goalWeight = 0;
  double initialWeight = 0;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoadingWeight = true;
  String? weightError;

  // Calculate progress (0.0 to 1.0)
  double get progress {
    if (initialWeight == 0 || goalWeight == 0 || initialWeight == goalWeight) {
      return 0.0;
    }
    return ((initialWeight - currentWeight) / (initialWeight - goalWeight))
        .clamp(0.0, 1.0);
  }

  // Data maps
  final Map<String, dynamic> fitnessData = {
    'steps': 8543,
    'activeMinutes': 45,
    'caloriesBurned': 420,
    'sleep': 7.5, // Fixed: added sleep data
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

  @override
  void initState() {
    super.initState();
    _controllerKg = FixedExtentScrollController(
      initialItem: kgValues.indexOf(selectedWeightKg),
    );
    _controllerLbs = FixedExtentScrollController(
      initialItem: lbsValues.indexOf(selectedWeightLbs),
    );
    _fetchWeightData(); // Fixed: renamed method
  }

  Future<void> _fetchWeightData() async {
    try {
      setState(() {
        isLoadingWeight = true;
        weightError = null;
      });

      // Get user data (contains current_weight and target_weight)
      final userData = await ApiService.getRequest("user/");

      // Get initial weight from matrics API (first weight entry)
      final weightData = await MatricApi.getMatricByType('weight');

      setState(() {
        // Set current weight from user API
        currentWeight = (userData['current_weight'] ?? 0).toDouble();

        // Set goal weight from user API (note: using 'target_weight' not 'targetweight')
        goalWeight = (userData['target_weight'] ?? 0).toDouble();

        // Set initial weight from matrics API - get the FIRST (oldest) weight entry
        if (weightData != null && weightData.isNotEmpty) {
          // Sort by created_at to get the oldest entry first
          weightData.sort(
            (a, b) => DateTime.parse(
              a['created_at'],
            ).compareTo(DateTime.parse(b['created_at'])),
          );
          initialWeight =
              (weightData.first['value'] ?? currentWeight).toDouble();
        } else {
          // Fallback to current weight if no matrics data
          initialWeight = currentWeight;
        }

        // Update selected weight for bottom sheet
        selectedWeightKg = currentWeight.toInt();
        selectedWeightLbs = (currentWeight * 2.20462).toInt();

        // Update controllers
        _controllerKg = FixedExtentScrollController(
          initialItem: kgValues.indexOf(selectedWeightKg.clamp(30, 200)),
        );
        _controllerLbs = FixedExtentScrollController(
          initialItem: lbsValues.indexOf(selectedWeightLbs.clamp(66, 336)),
        );

        isLoadingWeight = false;
      });
    } catch (e) {
      setState(() {
        isLoadingWeight = false;
        weightError = "Failed to load weight data: ${e.toString()}";
      });
    }
  }

  Future<void> _updateWeight(double newWeightKg) async {
    if (!mounted) return;

    try {
      setState(() {
        _isButtonEnabled = false;
      });

      final body = {"current_weight": newWeightKg.toInt()};
      await ApiService.putRequest("user/", body);

      setState(() {
        currentWeight = newWeightKg;
        _isButtonEnabled = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Weight updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isButtonEnabled = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update weight: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    final controller =
        isKg ? _controllerKg : _controllerLbs; // Fixed: removed asterisks
    final values = isKg ? kgValues : lbsValues;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Weight",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222326),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "kg",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setModalState(() => isKg = !isKg),
                        child: Container(
                          width: 44,
                          height: 24,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C0C0C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment:
                                isKg
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "lbs",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isKg ? "$selectedWeightKg kg" : "$selectedWeightLbs lbs",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222326),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFDCE2EA),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: ListWheelScrollView.useDelegate(
                            controller: controller,
                            itemExtent: 25,
                            diameterRatio: 100,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
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
                                        height: 50,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 1,
                                            height: isLong ? 50 : 30,
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
                                            top: 4,
                                          ),
                                          child: Text(
                                            '$val',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
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
                        Positioned(
                          top: 20,
                          bottom: 20,
                          child: Container(
                            width: 2,
                            color: const Color(0xFF0C0C0C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed:
                            _isButtonEnabled
                                ? () async {
                                  final double updatedWeightKg =
                                      isKg
                                          ? selectedWeightKg.toDouble()
                                          : selectedWeightLbs / 2.20462;

                                  await _updateWeight(updatedWeightKg);

                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C0C0C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child:
                            _isButtonEnabled
                                ? const Text(
                                  "Done",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                                : const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
            title: const Text('Select Image Source'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                child: const Text('Gallery'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                child: const Text('Camera'),
              ),
            ],
          ),
    );
  }

  Widget _buildPlanCard(
    String title,
    String subtitle,
    String iconPath,
    BuildContext context,
    Widget targetScreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
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
              margin: const EdgeInsets.only(right: 12),
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
                  const SizedBox(height: 2),
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
    if (isLoadingWeight) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text("Loading weight data..."),
            ],
          ),
        ),
      );
    }

    if (weightError != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              weightError!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchWeightData,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 160,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomPaint(
                    size: const Size(160, 80),
                    painter: RainbowHalfCirclePainter(progress: progress),
                  ),
                ),
              ),
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
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Weight Goal: ${goalWeight.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: () => _showWeightBottomSheet(context, 170),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
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
    Widget destinationScreen, // 👈 add screen to navigate
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destinationScreen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(icon, width: 34, height: 34),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
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
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      const CircleAvatar(radius: 16, child: Icon(Icons.person)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildWeightTracker(),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Plan is ready",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPlanCard(
                      'Diet',
                      '2000 kcal target',
                      'assets/icons/diet_icon.png',
                      context,
                      DietScreen(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPlanCard(
                      'Workout',
                      '15-30 min session',
                      'assets/icons/fitness_icon.png',
                      context,
                      WorkoutScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    CalorieTrackerScreen(),
                  ),
                  _buildActivityCard(
                    'Calories Burned',
                    '${fitnessData['caloriesBurned']}',
                    '/2,500',
                    'assets/icons/calories.png',
                    CalorieTrackerScreen(),
                  ),
                  _buildActivityCard(
                    'Steps',
                    '${fitnessData['steps']}',
                    '/20,000',
                    'assets/icons/steps.png',
                    StepsScreen(),
                  ),
                  _buildActivityCard(
                    'Water',
                    '${nutritionData['water']}',
                    '/6 Lt',
                    'assets/icons/water.png',
                    WaterIntakeScreen(),
                  ),
                  _buildActivityCard(
                    'Sleep',
                    '${fitnessData['sleep']}',
                    '/8hr',
                    'assets/icons/sleep.png',
                    SleepTrackerScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress Journey',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all images'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                          : const Column(
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
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogoutButton()),
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
  final double progress;

  RainbowHalfCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint =
        Paint()
          ..color = const Color(0xFFC9C9C9)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, math.pi, math.pi, false, bgPaint);

    final gradient = const SweepGradient(
      startAngle: math.pi,
      endAngle: 2 * math.pi,
      colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green],
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
