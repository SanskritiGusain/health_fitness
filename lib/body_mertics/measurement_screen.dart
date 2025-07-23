import 'package:flutter/material.dart';
import 'package:test_app/body_mertics/chest_measurement_screen.dart';
import 'package:test_app/body_mertics/tdee_screen.dart';
import 'body_weight_screen.dart';
import 'body_height_screen.dart';
import 'body_neck_screen.dart';
import 'chest_measurement_screen.dart';
import 'arms_measurement_screen.dart';
import 'waist_measurement_screen.dart';
import 'thigh_measurement_screen.dart';
import 'hip_measurement_screen.dart';
import 'body_fat_screen.dart';
import 'bmi_screen.dart';
import 'bmr_screen.dart';
import 'tdee_screen.dart';
import 'package:test_app/utils/custom_date_picker.dart'; // Add this import for your custom calendar

class MeasurementScreen extends StatefulWidget {
  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  DateTime selectedDate = DateTime.now();
  
  final Map<String, String> mockData = {
    "Body weight": "55 kg",
    "Body height": "165 cm",
    "Neck": "15 in",
    "Chest": "30 in",
    "Arms": "7 in",
    "Waist": "30 in",
    "Thigh": "20 in",
    "Hip": "34 in",
    "Body Fat": "18.5%",
    "BMI": "20.6 normal",
    "BMR": "1370 kcal/day",
    "TDEE": "1888 kcal/day",
  };

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

  // Updated method to use your custom calendar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB), 
        shadowColor: Colors.transparent, 
        centerTitle: true,
        toolbarHeight: 80,
        title: _buildDateSelector(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Horizontal line (divider)
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),

          // Actual scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Measurements",
                    style: TextStyle(
                        color: Color(0xFF222326),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Monitor key body measurements to understand your overall health trends",
                    style: TextStyle(
                        color: Color(0xFF767780), fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(context, "Weight and Height", ["Body weight", "Body height"]),
                  _buildSection(context, "Body Measurements", ["Neck", "Chest", "Arms", "Waist", "Thigh", "Hip"]),
                  _buildSection(context, "Body Metrics", ["Body Fat", "BMI", "BMR", "TDEE"]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildSection(BuildContext context, String title, List<String> keys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: keys.map((key) => _buildTile(context, key, mockData[key]!)).toList(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildTile(BuildContext context, String title, String value) {
    final isValueAdded = value.toLowerCase() != "not added";

    String numberPart = value;
    String unitPart = "";

    if (isValueAdded) {
      final parts = value.split(RegExp(r'\s+'));
      if (parts.length > 1) {
        numberPart = parts.first;
        unitPart = parts.sublist(1).join(' ');
      }
    }

    return InkWell(
      onTap: () => _navigateToMeasurementScreen(context, title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF222326)),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF767780)),
              ],
            ),
            const SizedBox(height: 6),
            isValueAdded
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$numberPart ",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF222326)),
                        ),
                        TextSpan(
                          text: unitPart,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF767780)),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    "Not added",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF767780),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _navigateToMeasurementScreen(BuildContext context, String measurementType) {
    int calculatedBmr = 1370;
    int calculatedTdee = 1800;
    switch (measurementType) {
      case "Body weight":
        Navigator.push(context, MaterialPageRoute(builder: (context) => BodyWeightScreen()));
        break;
      case "Neck":
        Navigator.push(context, MaterialPageRoute(builder: (context) => BodyNeckScreen()));
        break;
      case "Body height":
        Navigator.push(context, MaterialPageRoute(builder: (context) => BodyHeightScreen()));
        break;
      case "Body Fat":
        Navigator.push(context, MaterialPageRoute(builder: (context) => BodyFatScreen()));
        break;
      case "BMI":
        Navigator.push(context, MaterialPageRoute(builder: (context) => BMIScreen()));
        break;
      case "BMR":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BmrScreen(bmr: calculatedBmr),
          ),
        );
        break;
      case "Chest":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChestMeasurementScreen()));
        break;
      case "Arms":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArmsMeasurementScreen()));
        break;
      case "Waist":
        Navigator.push(context, MaterialPageRoute(builder: (context) => WaistMeasurementScreen()));
        break;
      case "Thigh":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ThighMeasurementScreen()));
        break;
      case "Hip":
        Navigator.push(context, MaterialPageRoute(builder: (context) => HipMeasurementScreen()));
        break;
      case "TDEE":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TdeeScreen(tdee: calculatedTdee),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$measurementType screen not implemented yet')),
        );
    }
  }
}