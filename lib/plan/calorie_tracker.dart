import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/utils/custom_date_picker.dart'; // Add this import for your custom calendar

class CalorieTrackerScreen extends StatefulWidget {
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  DateTime selectedDate = DateTime.now();
  String viewPeriod = 'Weekly';

  // Sample data
  final int totalBurn = 2100;
  final int bmr = 1000;
  final int activeBurn = 1100;
  final int consumedCalories = 2500;
  final int burnedCalories = 2100;
  final int netCalories = -400;
  final int dailyGoal = 2500;
  final int dailyBurnGoal = 2800;

  double get progress => burnedCalories / dailyBurnGoal;

  // Data for Calories Burned (Red line)
  List<FlSpot> getBurnedCaloriesData() {
    return [
      FlSpot(0, 1700),
      FlSpot(1, 1950),
      FlSpot(2, 2150),
      FlSpot(3, 2300),
      FlSpot(4, 2500),
      FlSpot(5, 2520),
      FlSpot(6, 2650),
    ];
  }

  // Data for Calories Consumed (Blue line)
  List<FlSpot> getConsumedCaloriesData() {
    return [
      FlSpot(0, 2200),
      FlSpot(1, 2100),
      FlSpot(2, 2400),
      FlSpot(3, 2300),
      FlSpot(4, 2500),
      FlSpot(5, 2600),
      FlSpot(6, 2700),
    ];
  }

  List<String> getDayLabels() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

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
      backgroundColor: Color(0xFFF8FBFB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8FBFB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildDateSelector(),
        centerTitle: true,
        actions: [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Calories Burned Summary",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "$totalBurn",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xFFF32C21)),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Total burn",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Resting (BMR):",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey)),
                      Spacer(),
                      Text("$bmr kcal",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Active:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey)),
                      Spacer(),
                      Text("$activeBurn kcal",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: Duration(seconds: 1),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.red,
                      minHeight: 6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    progress >= 1.0
                        ? "You've reached your goal!"
                        : "You're on track – Good job.",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildNetCaloriesSnapshot(),
            SizedBox(height: 24),
            _buildGoalSection(),
            SizedBox(height: 24),
            _buildAnalyticsChart(),
            SizedBox(height: 16),
            _buildTipsSection(),
          ],
        ),
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

  Widget _buildNetCaloriesSnapshot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Net Calories Snapshot',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildKeyValue('Consumed', '$consumedCalories kcal'),
              SizedBox(height: 8),
              _buildKeyValue('Burned', '$burnedCalories kcal'),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildKeyValue('Net', '$netCalories kcal',
                  valueColor: Colors.green),
              SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD6FAE4),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  "You're in a calorie surplus today",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
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
            fontWeight: FontWeight.w500,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Goal',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
          Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
         child: Column(
            children: [
        _buildKeyValue('Daily calories consumed goal', '$dailyGoal kcal'),
        SizedBox(height: 8),
        _buildKeyValue('Daily calories burned goal', '$dailyBurnGoal kcal'),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFCEE2FE),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Try to maintain calorie goal',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
            ],),),
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
            Text('Analytics',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => viewPeriod = value),
              itemBuilder: (context) => ['Weekly', 'Monthly']
                  .map((e) => PopupMenuItem(value: e, child: Text(e)))
                  .toList(),
              child: Row(
                children: [
                  Text(viewPeriod,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Calories Burned Vs Calories Consumed',
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ),
        SizedBox(height: 20),
        Container(
          height: 250,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 500,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value.toInt() < getDayLabels().length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            getDayLabels()[value.toInt()],
                            style: TextStyle(color: Colors.grey[600], fontSize: 10),
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
                    reservedSize: 50,
                    interval: 500,
                    getTitlesWidget: (value, _) => Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Text(
                        '${value.toInt()}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 10),
                      ),
                    ),
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Calories Burned (Red line)
                LineChartBarData(
                  spots: getBurnedCaloriesData(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                      radius: 4,
                      color: Colors.red,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
                // Calories Consumed (Blue line)
                LineChartBarData(
                  spots: getConsumedCaloriesData(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                      radius: 4,
                      color: Colors.blue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              minY: 1500,
              maxY: 3000,
            ),
          ),
        ),
        SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Calories burned', Colors.red),
            SizedBox(width: 24),
            _buildLegendItem('Calories Consumed', Colors.blue),
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
          width: 12,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.teal, size: 20),
              SizedBox(width: 8),
              Text(
                'Understanding your calories balance',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.teal[800]),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...[
            'When you burn more calories than you consume, you\'re in a calorie deficit. This can lead to weight loss.',
            'When you consume more calories than you burn, you\'re in a calorie surplus. This can lead to weight gain.',
            
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
            margin: EdgeInsets.only(top: 8, right: 8),
            decoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.teal[800], fontSize: 10, ),
            ),
          ),
        ],
      ),
    );
  }
}