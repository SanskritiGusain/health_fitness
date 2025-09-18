import 'package:flutter/material.dart';
import '../utils/bmi_gauge_painter.dart';

class BMIResultScreen extends StatefulWidget {
  final double bmi;
  const BMIResultScreen({super.key, required this.bmi});

  @override
  State<BMIResultScreen> createState() => _BMIResultScreenState();
}

class _BMIResultScreenState extends State<BMIResultScreen> {
  @override
  Widget build(BuildContext context) {
    final double bmi = widget.bmi;
    final category = _getBMICategoryLabel(bmi);
    final categoryColor = _getCategoryColor(bmi);
    final message = _getBMICategoryMessage(bmi);

    return Scaffold(
       backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
         backgroundColor: const Color(0xFFF8FBFB),
        elevation: 0,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("BMI", style: TextStyle(color: Colors.black)),
        // centerTitle: true,
      ),
    
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // BMI Value Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 34),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 200),

              // Gauge Card (Red background like screenshot)
   
// Replace your existing Gauge Card with this
Padding(
  padding: const EdgeInsets.symmetric(horizontal:0),
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200, // height of the gauge card
        width: double.infinity,
        child: Center(
          child: CustomPaint(
            size: const Size(260, 130), // fill the card width
            painter: BMIGaugePainter(bmi),
          ),
        ),
      ),
    ),
  ),
),

              const SizedBox(height: 20),

              // Description
              const Text(
                "BMI (Body Mass Index) is a measure of body weight relative to height, used to classify individuals as underweight, normal weight, overweight, or obese.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7F7F7F),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    


    );
  }

  String _getBMICategoryLabel(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    if (bmi < 35) return "Obese";
    return "Extremely Obese";
  }

  String _getBMICategoryMessage(double bmi) {
    if (bmi < 18.5) return "You're in the underweight range.";
    if (bmi < 25) return "You're in the normal range.";
    if (bmi < 30) return "You're in the overweight range.";
    if (bmi < 35) return "You're in the obese range.";
    return "You're in the extremely obese range.";
  }

  Color _getCategoryColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF52C9F7);
    if (bmi < 25) return const Color(0xFF97CD17);
    if (bmi < 30) return const Color(0xFFFEDA00);
    if (bmi < 35) return const Color(0xFFF8931F);
    return const Color(0xFFFE0000);
  }
}
