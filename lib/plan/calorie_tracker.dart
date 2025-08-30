import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/utils/custom_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalorieTrackerScreen extends StatefulWidget {
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  DateTime selectedDate = DateTime.now();
  String viewPeriod = 'Weekly';

  // Sample data matching the image
  final int totalGoal = 2800;
  final int restingBurn = 700;
  final int activeBurn = 800;
  final int consumedCalories = 2500;
  final int burnedCalories = 2100;
  final int netCalories = -400;

  double get restingProgress => restingBurn / totalGoal;
  double get activeProgress => activeBurn / totalGoal;

  // Data for chart
  List<FlSpot> getBurnedCaloriesData() {
    return [
      FlSpot(0, 1800),
      FlSpot(1, 1900),
      FlSpot(2, 2000),
      FlSpot(3, 2200),
      FlSpot(4, 2300),
      FlSpot(5, 2400),
      FlSpot(6, 2100),
    ];
  }

  List<FlSpot> getConsumedCaloriesData() {
    return [
      FlSpot(0, 2000),
      FlSpot(1, 2100),
      FlSpot(2, 2300),
      FlSpot(3, 2200),
      FlSpot(4, 2400),
      FlSpot(5, 2500),
      FlSpot(6, 2500),
    ];
  }

  List<String> getDayLabels() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGoalSection(),
            SizedBox(height: 44),
            Text(
              'Net Calories Snapshot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            _intakeSection(),
            SizedBox(height: 24),
            
            _buildNetCaloriesSnapshot(),
            SizedBox(height: 24),
            _buildAnalyticsChart(),
            SizedBox(height: 16),
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

Widget _buildGoalSection() {
    double burned = 1000; // Example burned calories
    double totalGoal = 2800; // Example total goal
    double resting = 200;
    double active = 800;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular progress with center text
          Container(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey[300]!,
                    ),
                  ),
                ),

                // Progress arc (orange)
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: burned / totalGoal,
                    strokeWidth: 10,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),

                // Center text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${burned.toInt()} Kcal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Burned',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 24),

          // Right-side: stack curve + text
          Expanded(
            child: Stack(
               clipBehavior: Clip.none,
              children: [
                // Background curve
               Positioned.fill(
  child: SvgPicture.asset(
    'assets/icons/curve.svg',
    fit: BoxFit.fill, // 👈 fills both height and width
    color: Colors.orangeAccent,
  ),
)
,

                // Text content on top
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Goal: ${totalGoal.toInt()} Kcal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        children: [
                          TextSpan(text: 'Resting (BMR): '),
                          TextSpan(
                            text: '${resting.toInt()} kcal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        children: [
                          TextSpan(text: 'Active: '),
                          TextSpan(
                            text: '${active.toInt()} kcal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _intakeSection() {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          // First box
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2,500 Kcal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 16), // spacing between boxes
          // Second box
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2,100 Kcal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildNetCaloriesSnapshot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Icons row
             
           
              // Values
              _buildKeyValue('Consumed', '2,500kcal'),
              SizedBox(height: 12),
              _buildKeyValue('Burned', '2,100kcal'),
              SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 12),
              _buildKeyValue('Net', '-400 kcal', valueColor: Colors.green),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Text(
                  "You're in a calories surplus today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyValue(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewPeriod,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          'Calories Burned Vs Calories Consumed',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        SizedBox(height: 20),
        Container(
          height: 280,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 200,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey[200], strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value.toInt() < getDayLabels().length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            getDayLabels()[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    interval: 200,
                    getTitlesWidget:
                        (value, _) => Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Calories Burned (Red line)
                LineChartBarData(
                  spots: getBurnedCaloriesData(),
                  isCurved: true,
                  curveSmoothness: 0.2,
                  color: Colors.red,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter:
                        (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3,
                          color: Colors.red,
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        ),
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
                // Calories Consumed (Green line)
                LineChartBarData(
                  spots: getConsumedCaloriesData(),
                  isCurved: true,
                  curveSmoothness: 0.2,
                  color: Colors.green,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter:
                        (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3,
                          color: Colors.green,
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        ),
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              minY: 1600,
              maxY: 2600,
            ),
          ),
        ),
        SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Calories burned', Colors.red),
            SizedBox(width: 32),
            _buildLegendItem('Calories Consumed', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: const Color.fromARGB(255, 17, 17, 17), size: 20),
              SizedBox(width: 8),
              Text(
                'Understanding your calories balance',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 17, 17, 17),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...[
            'When you burn more calories than you consume, you\'re in a calorie deficit. This can lead to weight loss.',
            'When you consume more calories than you burn, you\'re in a calorie surplus. This can lead to weight gain.',
            'The difference between calories consumed and calories burned is your calorie balance for the day.',
          ].map(_buildTipItem),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 12, 12),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color.fromARGB(255, 7, 7, 7),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
