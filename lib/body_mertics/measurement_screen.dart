import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'body_weight_screen.dart';
import 'body_height_screen.dart';
import 'body_neck_screen.dart';
import 'package:test_app/body_mertics/result_screen.dart';
import 'package:test_app/theme/app_theme.dart';
import 'package:test_app/utils/custom_app_bars.dart';

import 'package:test_app/body_mertics/body_composition_screen.dart'; // This line imports the BodyCompositionScreen and BodyCompositionType
import 'bmi_screen.dart';
// This line imports the BodyCompositionScreen and BodyCompositionType

import 'package:test_app/utils/custom_date_picker.dart';
// In each of your measurement screen files

class BodyMeasurement {
  final BodyPart part;
  final int valueCm;
  final double valueIn;
  final DateTime date;
  BodyMeasurement({
    required this.part,
    required this.valueCm,
    required this.valueIn,
    required this.date,
  });
}

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});
  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  DateTime selectedDate = DateTime.now();

  final Map<String, String> mockData = {
    "Weight": "55 kg",
    "Height": "165 cm",
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
    "Visceral Fat": "2.5%",
    "Muscle Mass": "45.5%",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.backAppBar(context, "Body Metrics"),

      body: Column(
        children: [
          // Horizontal line (divider)
          Container(height: 1, color: Colors.grey.shade300),
          // Actual scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // Plan Progress Insights Section
                  _buildWeightProgressGraph(),
                  const SizedBox(height: 20),
                  // Weight Loss and Body Fat Insight Cards
                  _buildInsightCards(),
                  const SizedBox(height: 20),
                  // Weekly Weight Progress Graph
                  const SizedBox(height: 24),
                  _buildSection(context, "Body Measurements", [
                    "Weight",
                    "Height",
                    "Neck",
                    "Chest",
                    "Arms",
                    "Waist",
                    "Thigh",
                    "Hip",
                  ]),
                  _buildSection(context, "Body Metrics", [
                    "Body Fat",
                    "BMI",
                    "BMR",
                    "TDEE",
                    "Visceral Fat",
                    "Muscle Mass",
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Add Ask Luna API here
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation to different screens based on index
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/home.png", height: 24),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/diet.png", height: 24),
            label: "Diet",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/workout.png", height: 24),
            label: "Workout",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/metrics.png", height: 24),
            label: "Metrics",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/tools .png", height: 24),
            label: "Tools",
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCards() {
    return Row(
      children: const [
        Expanded(
          child: InsightCard(title: "Weight Lost", value: "14", unit: "kg"),
        ),
        SizedBox(width: 12),
        Expanded(
          child: InsightCard(
            title: "Body Fat",
            value: "2.1%",
            isDrop: true,
            unit: " ",
          ),
        ),
      ],
    );
  }

  Widget _buildWeightProgressGraph() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Weight Progress",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.transparent,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y}Kg',
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final labels = [
                          'W1',
                          'W2',
                          'W3',
                          'W4',
                          'W5',
                          'W6',
                          'W7',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 26, right: 26),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        } else {
                          return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.teal,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.withOpacity(0.8),
                          Colors.white.withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: false),
                    spots: const [
                      FlSpot(0, 60),
                      FlSpot(1, 59),
                      FlSpot(2, 58.5),
                      FlSpot(3, 58),
                      FlSpot(4, 57),
                      FlSpot(5, 56.5),
                      FlSpot(6, 56),
                    ],
                  ),
                ],
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelWithValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> keys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children:
              keys
                  .map(
                    (key) =>
                        _buildTile(context, key, mockData[key] ?? "Not added"),
                  )
                  .toList(),
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
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222326),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF767780),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Flexible(
              child:
                  isValueAdded
                      ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$numberPart ",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF222326),
                              ),
                            ),
                            TextSpan(
                              text: unitPart,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF767780),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                      : const Text(
                        "Not added",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF767780),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMeasurementScreen(
    BuildContext context,
    String measurementType,
  ) {
    int calculatedBmr = 1370;
    int calculatedTdee = 1800;

    switch (measurementType) {
      case "Weight":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BodyWeightScreen()),
        );
        break;
      case "Neck":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.neck),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Neck measurement: ${measurement.valueCm} cm');
          }
        });
        break;
      case "Height":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BodyHeightScreen()),
        );
        break;
      case "Body Fat":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    BodyCompositionScreen(type: BodyCompositionType.bodyFat),
          ),
        );
        break;
      case "BMI":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BMIScreen(bmi: 23.4)),
        );
        break;
      case "BMR":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  title: "BMR",
                  value: 1500,
                  unit: "Kcal/day",
                  description:
                      "BMR (Basal Metabolic Rate) is the number of calories your body needs to perform basic functions like breathing and digestion while at rest.",
                  onAskLuna: () {
                    // TODO: Call BMR specific Luna API
                  },
                ),
          ),
        );
        break;

      case "Chest":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.chest),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Updated chest measurement: ${measurement.valueCm} cm');
          }
        });
        break;
      case "Arms":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.arms),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Updated arms measurement: ${measurement.valueCm} cm');
          }
        });
        break;
      case "Waist":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.waist),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Updated waist measurement: ${measurement.valueCm} cm');
          }
        });
        break;
      case "Thigh":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.thighs),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Updated thighs measurement: ${measurement.valueCm} cm');
          }
        });
        break;
      case "Hip":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyMeasurementScreen(bodyPart: BodyPart.hips),
          ),
        ).then((measurement) {
          if (measurement != null) {
            print('Updated hip measurement: ${measurement.valueCm} cm');
          }
        });
      case "TDEE":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  title: "TDEE",
                  value: 2200,
                  unit: "Kcal/day",
                  description:
                      "TDEE (Total Daily Energy Expenditure) is the total number of calories you burn each day including exercise, work, and daily activities.",
                  onAskLuna: () {
                    // TODO: Call TDEE specific Luna API
                  },
                ),
          ),
        );
        break;

      case "Visceral Fat":
        // For Visceral Fat:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BodyCompositionScreen(
                  type: BodyCompositionType.visceralFat,
                ),
          ),
        );
        break;
      case "Muscle Mass":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    BodyCompositionScreen(type: BodyCompositionType.muscleMass),
          ),
        );

        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$measurementType screen not implemented yet'),
          ),
        );
    }
  }
}

class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final bool isDrop;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    this.isDrop = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor =
        isDrop ? const Color.fromARGB(255, 55, 126, 240) : Colors.teal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 2),
              if (isDrop)
                const Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: Color.fromARGB(255, 55, 126, 240),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 141, 141, 141),
            ),
          ),
        ],
      ),
    );
  }
}