import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/utils/custom_date_picker.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  DateTime selectedDate = DateTime.now();
  
  // Mock data - you can replace this with actual data from your backend
  Map<String, Map<String, dynamic>> stepsData = {
    '2025-07-25': {
      'steps': 9716,
      'goal': 10000,
      'duration': '3 hrs',
      'distance': '6.1 km',
      'calories': '548 kcal',
      'weeklyData': [2500, 2800, 2900, 2400, 3100, 2600, 2900], // Mon-Sun
      'message': 'Great job! Just 284 steps left.'
    },
    // Add more dates as needed
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
 Future<void> _showAddTimeDialog() async {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF8F8F8), // light background color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(30),

        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 320, // custom width
              height: 220, // custom height
              child: Column(
                
                mainAxisSize: MainAxisSize.min,
                children: [

Align(
  
  alignment: Alignment.centerLeft,
  child: Text(
    "Add Activity Time",
    style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),
  ),
),
 // ✅ Comma added here

                  const SizedBox(height: 25),


                 

                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // Start Time Picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start Time"),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  startTime = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        //  width: 100, 
                              decoration: BoxDecoration(
                             
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Text(
                                startTime?.format(context) ?? "05:35 am",
                                style: const TextStyle(color: Color.fromARGB(255, 157, 156, 156)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // End Time Picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("End Time"),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  endTime = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                // width: 100, 
                              decoration: BoxDecoration(
                                
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Text(
                                endTime?.format(context) ?? "06:00 am",
                                style: const TextStyle(color: Color.fromARGB(255, 153, 153, 153)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Save logic here
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    },
  );
}


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

  Widget _buildAppBarDateSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
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

  Widget _buildStatsCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildWeeklyChart(List<int> weeklyData) {
    int maxValue = weeklyData.reduce((a, b) => a > b ? a : b);
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Y-axis labels
          Expanded(
            child: Row(
              children: [
                // Y-axis
                SizedBox(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${maxValue}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('${(maxValue * 0.75).toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('${(maxValue * 0.5).toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('${(maxValue * 0.25).toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const Text('0', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Chart area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: weeklyData.asMap().entries.map((entry) {
                            int index = entry.key;
                            int value = entry.value;
                            double height = maxValue > 0 ? (value / maxValue) * 140 : 0;
                            
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 16, // Decreased width
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 109, 181, 111),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // X-axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: days.map((day) => Text(
                          day,
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // X-axis title
         
        ],
      ),
    );
  }

  Widget _buildWithDataContent(Map<String, dynamic> data) {
    double progress = data['steps'] / data['goal'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Points section above card
      Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const Text(
        "Today's Steps",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ),
    Row(
  mainAxisSize: MainAxisSize.min, // Keeps the row compact
  children: [
  Image.asset(
    'assets/icons/pts_icon.png',
    height: 16,
    width: 16,
  ),
  const SizedBox(width: 4),
  const Text(
    '80 pts',
    style: TextStyle(
      fontSize: 12,
     
      fontWeight: FontWeight.w500,
    ),
  ),
],

),

    ],
  ),
),

        
        const SizedBox(height: 8),
        
        // Steps Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data['steps']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Goal: ${data['goal']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress > 1.0 ? 1.0 : progress,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                minHeight: 4,
              ),
              const SizedBox(height: 8),
            Center(
  child: Text(
    data['message'],
    style: const TextStyle(
      fontSize: 12,
      color: Color.fromARGB(255, 62, 62, 62),
    ),
  ),
),

            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Individual Stats Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(child: _buildStatsCard('Duration', data['duration'])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatsCard('Distance', data['distance'])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatsCard('Calories', data['calories'])),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
     
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          
          child: Column(
            children: [
                 // Weekly Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              DropdownButton<String>(
                value: 'Weekly',
                underline: Container(),
                icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                items: ['Weekly', 'Monthly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown change
                },
              ),
            ],
          ),
        ),
              _buildWeeklyChart(data['weeklyData']),
              // Y-axis label
             
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildNoDataContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Today's Steps",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 26, 25, 25),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Main no-data card
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Column(
          children: [
            SizedBox(height: 20),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Empty Stats Cards Row
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildStatsCard('Duration', '-')),
            const SizedBox(width: 12),
            Expanded(child: _buildStatsCard('Distance', '-')),
            const SizedBox(width: 12),
            Expanded(child: _buildStatsCard('Calories', '-')),
          ],
        ),
      ),

      const SizedBox(height: 30),

      // Second no-data card (e.g., for chart or extra section)
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ],
  );
}

@override
Widget build(BuildContext context) {
  String dateKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
  Map<String, dynamic>? dayData = stepsData[dateKey];
  bool hasData = dayData != null;

  return Scaffold(
       backgroundColor: const Color(0xFFF8FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFB),
        surfaceTintColor: const Color(0xFFF8FBFB), 
        shadowColor: Colors.transparent, 
        centerTitle: true,
        toolbarHeight: 80,
         title:_buildAppBarDateSelector(),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
     
    
     
    ),
 body: SingleChildScrollView(
      child: Column(
        children: [
           Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          // Header Row with Steps title and Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              TextButton.icon(
  onPressed: _showAddTimeDialog,
  icon: const Icon(Icons.add, color: Colors.green, size: 16),
  label: const Text(
    'Add',
    style: TextStyle(
      color: Colors.green,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
),

              ],
            ),
          ),
          const SizedBox(height: 10),
          hasData ? _buildWithDataContent(dayData) : _buildNoDataContent(),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

}