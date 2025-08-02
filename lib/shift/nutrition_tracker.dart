import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/utils/custom_date_picker.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final double protein = 140;
  final double carbs = 230;
  final double fat = 97;
  

  DateTime selectedDate = DateTime.now();

  String get displayDateText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected == today) return "Today";
    if (selected == today.subtract(const Duration(days: 1))) return "Yesterday";
    if (selected == today.add(const Duration(days: 1))) return "Tomorrow";
    return "${selected.day.toString().padLeft(2, '0')} ${_getMonthName(selected.month)}";
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
      final double total = protein + carbs + fat;
  final double proteinPercent = (protein / total) * 100;
  final double carbsPercent = (carbs / total) * 100;
  final double fatPercent = (fat / total) * 100;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildDateSelector(),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Daily Nutrition", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          const Text("Smart meals to nourish your body and energize your day", style: TextStyle(fontSize: 10,color: Color.fromARGB(255, 140, 140, 140))),
          const SizedBox(height: 24),
          _dailyGoalCard(),
          const SizedBox(height: 24),
          _mealSection("assets/new_icons/breakfast.png","Breakfast"),
          _mealSection("assets/new_icons/lunch.png","Lunch"),
          _mealSection("assets/new_icons/dinner.png","Dinner"),
          const SizedBox(height: 54),
          const Text("Macronutrient Breakdown", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

          const Text("Percentage of each macro.", style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 16),
         Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  padding: const EdgeInsets.symmetric(vertical: 16),
  child: Column(
    children: [

      _macroChart(proteinPercent, carbsPercent, fatPercent),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _macroLegend(Colors.green, 'Protein', proteinPercent, protein),
          _macroLegend(Colors.blue, 'Carbs', carbsPercent, carbs),
          _macroLegend(Colors.amber[700]!, 'Fat', fatPercent, fat),
        ],
      ),
    ],
  ),
),

        ],
      ),
    );
  }

  Widget _dailyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset("assets/new_icons/nutrition.png", height: 40, width: 40),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's fuel goal: 2800 kcal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text("Based on your goal to maintain current weight", style: TextStyle(fontSize: 10,color: Color.fromARGB(255, 146, 145, 145),fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _mealSection(String imageUrl, String mealName) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: Image.asset(imageUrl, width: 36, height: 36, fit: BoxFit.cover),
          title: Text(
            mealName,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          trailing: const Icon(Icons.add_circle_rounded, ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Column(
            children: [
              _foodItemTile("Rice", "100g", "130 kcal", "2g", "28g", "0.3g"),
              _foodItemTile("Pork", "100g", "297 kcal", "25g", "0g", "21g"),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _foodItemTile(String food, String serving, String kcal, String protein, String carbs, String fat) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.fromLTRB(10,0, 4, 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color.fromARGB(255, 211, 209, 209),width:1.0),
 
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row with food title and delete icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         
                  Text("$food $serving  |  $kcal", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  

            IconButton(
              onPressed: () {
                // You can implement delete logic here
              },
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
              splashRadius: 20,
            ),
          ],
        ),
        const SizedBox(height: 0),
        Row(
          children: [
            _macroChip("P", protein),
            _macroChip("C", carbs),
            _macroChip("F", fat),
          ],
        ),
      ],
    ),
  );
}


  Widget _macroChip(String label, String value) {
  Color color;
  switch (label) {
    case 'P':
      color = Colors.green;
      break;
    case 'C':
      color = Colors.blue;
      break;
    case 'F':
      color = Colors.orange;
      break;
    default:
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1),
    child: Chip(
      label: Text(
        "$label: $value",
        style: TextStyle(fontSize: 10, color: color), // Remove const here
      ),
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.compact,
      // padding: const EdgeInsets.symmetric(horizontal: 2),
     
    ),
  );
}


Widget _macroChart(double proteinPercent, double carbsPercent, double fatPercent) {
  return AspectRatio(
    aspectRatio: 1.3,
    child: PieChart(
      PieChartData(
        centerSpaceRadius: 70,
        sectionsSpace: 4,
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: proteinPercent,
            radius: 18,
            showTitle: false,
          ),
          PieChartSectionData(
            color: Colors.blue,
            value: carbsPercent,
            radius: 18,
            showTitle: false,
          ),
          PieChartSectionData(
            color: Colors.amber[700],
            value: fatPercent,
            radius: 18,
            showTitle: false,
          ),
        ],
      ),
    ),
  );
}


  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: _shadowBox(),
      child: Icon(icon, size: 16),
    );
  }

  BoxDecoration _shadowBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4)],
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
                Text(displayDateText, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 21, color: Colors.black),
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
  Widget _macroLegend(Color color, String label, double percent, double grams) {
  return Column(
    children: [
      Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 5),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      const SizedBox(height: 4),
      Text("${percent.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 13, color: Colors.black54)),
      Text("${grams.toStringAsFixed(0)}g", style: const TextStyle(fontSize: 13, color: Colors.black45)),
    ],
  );
}
}