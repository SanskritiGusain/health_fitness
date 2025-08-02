import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:test_app/tools/tools_screen.dart'; 
import 'package:test_app/chat/chat_screen.dart'; 
import 'package:test_app/gamification/gamification_screen.dart'; 
import 'package:test_app/plan/fitness_wellness.dart'; 
import 'package:test_app/utils/custom_bottom_nav.dart'; 

class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  String selectedTimeFrame = 'Weekly'; // Add this state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     bottomNavigationBar: CustomBottomNav(
      currentIndex: 1, // 0 for Home
      onTap: (index) {
        if (index == 1) return; // Already on home
        
        switch (index) {
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ToolsScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWelcomeScreen()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => GamificationScreen()));
            break;
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessWellnessScreen()));
            break;
        }
      },
 ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Obesity Off', style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [Icon(Icons.more_vert, color: Colors.black)],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _progressCard(),
            _sectionTitle('Daily Goals'),
            _sectionSubTitle('Small steps every day lead to big results.'),
    
                   Container(
  margin: const EdgeInsets.symmetric(vertical: 16),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(4),
    // color: Colors.white,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [        _twoOptionColumn('Workout', "assets/new_icons/workout.png", 'Nutrition', "assets/new_icons/nutrition.png"),

    ],
  ),
),
            _sectionTitle('Insights'),
            _sectionSubTitle('Small steps every day lead to big results.'),

        Container(
  margin: const EdgeInsets.symmetric(vertical: 16),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(4),
    // color: Colors.white,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Body metrics'),
      _twoOptionColumn('Measurements', "assets/new_icons/measurement.png", 'Menstrual Cycle', "assets/new_icons/cycle.png"),
      _sectionTitle('Activity and Recovery'),
      _twoOptionColumn('Steps', "assets/icons/step_icon.png", 'Sleep', "assets/icons/sleep_icon.png"),
      _singleOptionRow('Recovery and Strain', "assets/new_icons/recovery.png"),
      _sectionTitle('Food & Fluids'),
      _twoOptionColumn('Calories', "assets/icons/calories_icon.png", 'Water', "assets/icons/water_icon.png"),
      _sectionTitle('Health Check-In'),
      _gridOptions([
        {'title': 'Resting Heart Rate', 'imageUrl': 'assets/new_icons/heart_r.png'},
        {'title': 'Heart Rate Variability', 'imageUrl': 'assets/new_icons/heart_v.png'},
        {'title': 'Oxygen Saturation (SpO2)', 'imageUrl': 'assets/new_icons/oxygen.png'},
        {'title': 'Body Temperature', 'imageUrl': 'assets/new_icons/temp.png'},
        {'title': 'Stress', 'imageUrl': 'assets/new_icons/stress.png'},
      ]),
    ],
  ),
),

            const SizedBox(height: 12),
            _sectionTitle('Calories Tracker'),
            _sectionSubTitle('Small steps every day lead to big results.'),
              // Stats row
        Row(
          children: [
            Expanded(
            child:  Container(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
     
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
Row(
  children: [
    Text(
      "Consumed",
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 30, 30, 30),
        fontWeight: FontWeight.w500,
      ),
    ),
  Spacer(), // Add spacing between text and image
    Image.asset(
      "assets/new_icons/consumed.png",
      width: 18, // Optional: define size
      height: 18,
      fit: BoxFit.contain,
    ),
  ],
),
             Row(
                  children: [
                      Text("2,300", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                       const SizedBox(width: 4),
                  Text("kcal", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
                ],
              ),),
            ),
            const SizedBox(width: 6),
            Expanded(
                   child:  Container(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
     
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
Row(
  children: [
    Text(
      "Burned",
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 30, 30, 30),
        fontWeight: FontWeight.w500,
      ),
    ),
   Spacer(), // Add spacing between text and image
    Image.asset(
      "assets/new_icons/Vector (23).png",
      width: 18, // Optional: define size
      height: 18,
      fit: BoxFit.contain,
    ),
  ],
),                Row(
                  children: [
                      Text("2,100", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                       const SizedBox(width: 4),
                  Text("kcal", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
                ],
              ),
                   ),
            ),
             const SizedBox(width: 6),
            Expanded(
                   child:  Container(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
     
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
Row(
  children: [
    Text(
      "Net balance",
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 30, 30, 30),
        fontWeight: FontWeight.w500,
      ),
    ),
 Spacer(),// Add spacing between text and image
    Image.asset(
      "assets/new_icons/Group 36.png",
      width: 18, // Optional: define size
      height: 18,
      fit: BoxFit.contain,
    ),
  ],
),               Row(
                children: [
                     Text("-2,100", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red)),
                      const SizedBox(width: 4),
                  Text("kcal", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
               )
                ],
              ),),
            ),
          ],
        ),
        const SizedBox(height: 20),
            _calorieGraphCard(),
            const SizedBox(height: 12),
        _calorieBalanceInfoCard(),  // new widget
const SizedBox(height: 12),
            _singleOptionRow('Other plans', "assets/new_icons/other_plan.png"),
          ],
        ),
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 20,
                  backgroundColor: const Color.fromARGB(255, 119, 196, 172),
                  valueColor: const AlwaysStoppedAnimation(Color.fromARGB(255, 15, 76, 58)),
                ),
              ),
              const Text("75%", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Plan Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Text("Your progress is your power", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 114, 114, 114))),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _sectionSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 112, 112, 112))),
    );
  }

  Widget _twoOptionColumn(String title1, String imageUrl1, String title2, String imageUrl2) {
    return 
  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _optionCard(title1, imageUrl1),
          // const SizedBox(height: 1),
          _optionCard(title2, imageUrl2),
        ],
      );
 
  }

  Widget _singleOptionRow(String title, String imageUrl) => _optionCard(title, imageUrl);

  Widget _optionCard(String title, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
    
        Image.asset(
            imageUrl,
            height: 34,
            width: 34,
          ),

          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          const Icon(Icons.chevron_right,color: Colors.grey,),
        ],
      ),
    );
  }

  Widget _gridOptions(List<Map<String, String>> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _optionCard(item['title']!, item['imageUrl']!)).toList(),
    );
  }

Widget _calorieGraphCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and dropdown
        Row(
          children: [
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 243, 242, 242),width:1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: StyledDropdownButton(
                value: selectedTimeFrame,
                items: const ['Weekly', 'Monthly', 'Quarterly', 'Yearly'],
                buttonColor: const Color(0xFFF8FBFB),
                textColor: Color(0xFF222326),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedTimeFrame = newValue;
                    });
                  }
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        
        // Subtitle
       
        
      
        
      SizedBox(
  height: 200,
  child: LineChart(
    LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 3000,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 500,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 500,
            getTitlesWidget: (value, _) {
              if (value % 500 == 0) {
                return Text('${value.toInt()}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (value >= 0 && value < days.length) {
                return Text(days[value.toInt()],
                    style: const TextStyle(fontSize: 10, color: Colors.grey));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        // Burned Calories Line
        LineChartBarData(
          spots: [
            FlSpot(0, 1800),
            FlSpot(1, 2000),
            FlSpot(2, 2200),
            FlSpot(3, 2400),
            FlSpot(4, 2300),
            FlSpot(5, 2500),
            FlSpot(6, 2600),
          ],
          isCurved: true,
          color: const Color.fromARGB(255, 216, 43, 43),
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 4,
              color: const Color.fromARGB(255, 38, 37, 37),
              strokeWidth: 0,
            ),
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // Consumed Calories Line
        LineChartBarData(
          spots: [
            FlSpot(0, 1900),
            FlSpot(1, 2100),
            FlSpot(2, 2000),
            FlSpot(3, 2300),
            FlSpot(4, 2200),
            FlSpot(5, 2400),
            FlSpot(6, 2700),
          ],
          isCurved: true,
          color: const Color.fromARGB(255, 4, 167, 99),
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 4,
              color: Colors.black,
              strokeWidth: 0,
            ),
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 1800,
            color: Colors.grey.shade300,
            strokeWidth: 1,
            dashArray: [4, 4],
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (line) => 'Avg.',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    ),
  ),
),

      ],
    ),
  );
}

Widget _calorieBalanceInfoCard() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.teal.shade50,
      border: Border.all(color: Colors.teal.shade100),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.teal, size: 18),
            SizedBox(width: 8),
            Text(
              "Understanding your calories balance:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _infoBullet(
          "When calories burned exceed calories consumed, you're in a caloric deficit (good for weight loss).",
        ),
        const SizedBox(height: 8),
        _infoBullet(
          "When calories consumed exceed calories burned, you're in a caloric surplus (good for weight gain).",
        ),
        const SizedBox(height: 8),
        _infoBullet(
          "The reference line shows a typical daily calories target for maintenance.",
        ),
      ],
    ),
  );
}

Widget _infoBullet(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Icon(Icons.circle, size: 6, color: Colors.black54),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
    ],
  );
}

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Unlock insights by syncing your wearable or health app data.",
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}

// Custom Styled Dropdown Button
class StyledDropdownButton extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? buttonColor;
  final Color? textColor;

  const StyledDropdownButton({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<StyledDropdownButton> createState() => _StyledDropdownButtonState();
}

class _StyledDropdownButtonState extends State<StyledDropdownButton> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4.0),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
               
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.map((item) {
                  return _buildDropdownItem(item);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String item) {
    final isSelected = item == widget.value;
    
    return InkWell(
      onTap: () {
        widget.onChanged(item);
        _closeDropdown();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF222326),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
       
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.textColor ?? Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ],
          ),
     
      ),
    );
  }
}