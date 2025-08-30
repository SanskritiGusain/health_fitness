import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class PlanInsightScreen extends StatelessWidget {
  const PlanInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Plan Insight', style: TextStyle(fontSize: 14)),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: const Color.fromARGB(255, 222, 218, 218),
            ),
            const SizedBox(height: 20),
            sectionTitle("Plan Progress Insights"),
            const Text(
              "Plan Progress Plan . Week 7 of 12",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 12),

            /// Section 1: Plan Completion + Progress Bar + Start/Remaining Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWithValue("Plan Completion", "65%"),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: 0.65,
                    progressColor: const Color.fromARGB(255, 36, 37, 37),
                    backgroundColor: Colors.grey[300],
                    barRadius: const Radius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Started - March 5, 2025",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        "5 weeks remaining",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Insight Cards
            Row(
              children: const [
                Expanded(
                  child: InsightCard(
                    title: "Weight Lost",
                    value: "14",
                    unit: "kg",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InsightCard(
                    title: "Body Fat",
                    value: "2.1%",
                    isDrop: true,
                    unit: " ",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// Section 2: Weight Tiles
            sectionTitle("Weight Insight"),
            const Text(
              "Your weight journey over the past 7 weeks",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                WeightTile(title: "Current Weight", value: "56", unit: "kg"),
                WeightTile(title: "Targeted Weight", value: "52", unit: "kg"),
              ],
            ),

            const SizedBox(height: 16),

            /// Section 3: Progress to Goal + Progress Bar + Remaining Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWithValue("Progress to Goal", "65%"),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: 0.65,
                    progressColor: const Color.fromARGB(255, 46, 47, 47),
                    backgroundColor: Colors.grey[300],
                    barRadius: const Radius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "4 kg to go",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 68, 67, 67),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Section 4: Weekly Weight Progress Title + Graph
            /// Section 4: Weekly Weight Progress Title + Graph
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Weekly Weight Progress"),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            // tooltipBgColor: Colors.transparent, // Transparent tooltip background
                            // tooltipRoundedRadius: 8,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y}Kg', // Show Y value
                                  const TextStyle(
                                    color: Colors.black, // Black text
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
                                  return Text(
                                    labels[value.toInt()],
                                    style: const TextStyle(fontSize: 10),
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
                            dotData: FlDotData(show: true),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget labelWithValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
        ),
      ],
    );
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

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        // width: double.infinity,
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
      ),
    );
  }
}

class WeightTile extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const WeightTile({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
