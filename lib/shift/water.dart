import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:test_app/utils/custom_date_picker.dart';

class WaterIntakeScreen extends StatefulWidget {
  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  double consumed = 1.0;
  final double goal = 3.0;

  void increase() {
    if (consumed < goal) {
      setState(() {
        consumed += 0.5;
      });
    }
  }

  void decrease() {
    if (consumed > 0.0) {
      setState(() {
        consumed -= 0.5;
      });
    }
  }  DateTime selectedDate = DateTime.now();

  String get displayDateText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected == today) {
      return "Today";
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else if (selected == today.add(const Duration(days: 1))) {
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
    void _navigateToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }
    void _navigateToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }
    Future<void> _showDatePicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double progress = consumed / goal;
    // Calculate the height of the water based on progress (0.0 to 1.0)
    // We subtract from 250 because the wave should start from the bottom
    double waterHeight = 545 * progress.clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
      title: _buildDateSelector(),
        centerTitle: true,
 leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,size:20),
          onPressed: () => Navigator.pop(context),
        ),        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children:  [
                Text(
                  "Water Intake",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Spacer(),
              // Image.asset('assets/images/points_icon.png', height: 100),
               Image.asset(
      'assets/icons/pts_icon.png',
      height: 16,
    ),
    Text(
      " 60 pts",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10,color:Colors.grey),
    ),
              ],
            ),                                  const SizedBox(height: 14),

            // TOP CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text("Daily Goal",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            Text("${goal.toInt()}L",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text("Water Consumed",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            Text("${consumed.toStringAsFixed(1)}L",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progress >= 1.0
                        ? "You've reached your goal!"
                        : "You're on track - Good job.",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Log Water",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 250,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Background container for the bottle (optional)
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                            bottom: Radius.circular(26),
                          ),
                        ),
                      ),
                      
                      // Water wave container
                      Positioned(
                        bottom: 0,
                        child: ClipRRect(
                       borderRadius: const BorderRadius.only(
  topLeft: Radius.circular(126),
   topRight: Radius.circular(126),
  bottomLeft: Radius.circular(84),
  bottomRight: Radius.circular(84),
),

                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            width: 76,
                            height: waterHeight,
                            child: WaveWidget(
                              config: CustomConfig(
                                gradients: [
                                    [Colors.lightBlue.shade300, Colors.lightBlue.shade100],
                                  [Colors.blue.shade400, Colors.blue.shade200],
                                
                                ],
                                durations: [3500, 19440],
                                heightPercentages: [0.55, 0.60],
                                blur: const MaskFilter.blur(BlurStyle.solid, 5),
                                gradientBegin: Alignment.bottomLeft,
                                gradientEnd: Alignment.topRight,
                              ),
                              waveAmplitude: progress < 0.1 ? 0 : 5, // Reduce amplitude when nearly empty
                              size: const Size(double.infinity, double.infinity),
                            ),
                          ),
                        ),
                      ),
                      
                      // Water bottle image overlay
                      Image.asset(
                        "assets/images/water_bottle.png", // Make sure you have this asset
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrease,
                  icon: const Icon(Icons.remove),
                  iconSize: 32,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fixedSize: const Size(48, 48),
                  ),
                ),
                const SizedBox(width: 24),
                Text("${consumed.toStringAsFixed(1)}L",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: increase,
                  icon: const Icon(Icons.add),
                  iconSize: 32,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fixedSize: const Size(48, 48),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 14),
                SizedBox(width: 4),
                Text(
                  "Daily water intake goals recommended by WHO",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildDateSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _navigateToPreviousDay,
          child: _iconButton(Icons.arrow_back_ios),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: _shadowBox(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(displayDateText,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    size: 21, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _navigateToNextDay,
          child: _iconButton(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
    Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _shadowBox(),
      child: Icon(icon, size: 16, color: Colors.black),
    );
  }
    BoxDecoration _shadowBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
}