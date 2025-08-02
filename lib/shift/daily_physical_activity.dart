import 'package:flutter/material.dart';
import 'package:test_app/utils/custom_date_picker.dart';
// Dummy CustomDatePicker for illustration


class DailyPhysicalActivitiesScreen extends StatefulWidget {
  const DailyPhysicalActivitiesScreen({super.key});

  @override
  State<DailyPhysicalActivitiesScreen> createState() =>
      _DailyPhysicalActivitiesScreenState();
}

class _DailyPhysicalActivitiesScreenState
    extends State<DailyPhysicalActivitiesScreen> {
  DateTime selectedDate = DateTime.now();

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

  void _navigateToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _navigateToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,size:20),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildDateSelector(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Physical Activities',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            const Text(
              'Assigned exercises and daily fitness tasks',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _goalCard(
              image: "assets/new_icons/burn.png",
              title: 'Burn 2,500 Kcal Today',
              subtitle: 'Stay active, stay focused, results follow effort.',
            ),
            const SizedBox(height: 24),
            const Text("Today's goal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _exerciseCard(
              image: "assets/new_icons/lucide_dumbbell.png",
              title: "Strength",
              target:
                  "• Squats – 3 sets × 15 reps\n• Lunges (each leg) – 2 sets × 12 reps",
              notes:
                  "Take 30–60 seconds rest between each exercise. After completing all exercises, rest for 1–2 minutes before repeating (optional).",
            ),
            _exerciseCard(
              image: "assets/new_icons/lucide_Heart.png",
              title: "Cardio",
              target: "• Jumping Jacks – 3 sets × 30 sec\n• Cycling – 1 hour",
              notes:
                  "Take 30–60 seconds rest between each exercise. After completing all exercises, rest for 1–2 minutes before repeating (optional).",
            ),
            _exerciseCard(
              image: "assets/new_icons/flexibility.png",
              title: "Flexibility",
              target:
                  "• Standing Forward Bend – Stretches hamstrings & back",
              notes:
                  "Take 30–60 seconds rest between each exercise. After completing all exercises, rest for 1–2 minutes before repeating (optional).",
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(image),
            radius: 10,
            // border:Border.all(color:Colors.grey,width: 2)
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                // const SizedBox(height: 2),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseCard({
    required String image,
    required String title,
    required String target,
    required String notes,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      // padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 226, 226, 226),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
       
          Container(
             padding: const EdgeInsets.only(left:14,top:10),
 child:   Row(
            children: [
              Container( 
                      padding: const EdgeInsets.all(4),decoration: BoxDecoration(
              
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),

        border: Border.all(color:Colors.grey,width:1.0)
      ),
      
              child: 
              Image.asset(image, width: 24, height: 24),
            ),
                const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
         color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Target",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(target, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Notes:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(notes,
                          style: const TextStyle(
                              fontSize: 10, color: Color.fromARGB(255, 18, 17, 17))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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