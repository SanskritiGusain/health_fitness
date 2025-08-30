import 'package:flutter/material.dart';
import 'package:test_app/utils/custom_date_picker.dart';
import 'package:test_app/new/cycle_insight.dart';

class CycleTrackerScreen extends StatefulWidget {
  @override
  _CycleTrackerScreenState createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends State<CycleTrackerScreen> {
  DateTime selectedMonth = DateTime(2025, 5); // May 2025
  DateTime periodStart = DateTime(2025, 5, 6);
  DateTime periodEnd = DateTime(2025, 5, 10);

  List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  List<int?> generateCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    int leadingEmptyDays = firstDay.weekday % 7;
    List<int?> days = List.filled(leadingEmptyDays, null, growable: true);

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(i);
    }

    return days;
  }

  Color getDayColor(int? day) {
    if (day == null) return Colors.transparent;
    final current = DateTime(selectedMonth.year, selectedMonth.month, day);

    if (current.isAtSameMomentAs(periodStart) ||
        current.isAtSameMomentAs(periodEnd) ||
        (current.isAfter(periodStart) && current.isBefore(periodEnd))) {
      return Colors.pink;
    }
    return Colors.transparent;
  }

  TextStyle getDayTextStyle(int? day) {
    if (day == null) {
      return const TextStyle(inherit: true);
    }

    Color bg = getDayColor(day);
    return TextStyle(
      inherit: true,
      color: bg == Colors.transparent ? Colors.black87 : Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<int?> calendarDays = generateCalendarDays(selectedMonth);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cycle',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Month Navigation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${monthName(selectedMonth.month)} ${selectedMonth.year}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    _monthNavButton(Icons.arrow_back_ios, () {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month - 1,
                        );
                      });
                    }),
                    SizedBox(width: 12),
                    _monthNavButton(Icons.arrow_forward_ios, () {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month + 1,
                        );
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),

          // Duration Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      weekDays[periodStart.weekday % 7],
                      style: _weekdayStyle(),
                    ),
                    Text(
                      weekDays[periodEnd.weekday % 7],
                      style: _weekdayStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${periodStart.day} ${monthName(periodStart.month)} ${periodStart.year}',
                      style: _dateStyle(),
                    ),
                    Text('to', style: TextStyle(color: Colors.black87)),
                    Text(
                      '${periodEnd.day} ${monthName(periodEnd.month)} ${periodEnd.year}',
                      style: _dateStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cycle Circle
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Average cycle length',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '28 Days',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    // Image under text
                    Image.asset(
                      "assets/icons/mensulation_cycle.png",
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Log Period Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                _openLogPeriodSheet(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Log Period',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Legend
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.green, 'Ovulation Days'),
                _buildLegendItem(Colors.blue, 'Fertility Days'),
                _buildLegendItem(Colors.red, 'Period Days'),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Calendar
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  // Week days header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        weekDays
                            .map(
                              (day) => SizedBox(
                                width: 40,
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 16),

                  // Calendar grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: calendarDays.length,
                      itemBuilder: (context, index) {
                        int? day = calendarDays[index];
                        return Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: getDayColor(day),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child:
                                day != null
                                    ? Text(
                                      day.toString(),
                                      style: getDayTextStyle(day),
                                    )
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cycle Insights
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CycleInsightScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cycle Insights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle _weekdayStyle() =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey);

  TextStyle _dateStyle() => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  Widget _monthNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

void _openLogPeriodSheet(BuildContext context) {
  DateTime? startDate;
  DateTime? endDate;
  String selectedPeriodFlow = 'Light'; // Default value
  
  // Additional information variables
  TextEditingController avgPeriodDurationController = TextEditingController(text: '5 Days');
  TextEditingController avgCycleLengthController = TextEditingController(text: '28 Days');
  TextEditingController isCycleRegularController = TextEditingController(text: 'Yes');
  TextEditingController medicalConditionController = TextEditingController(text: 'PCOS');
  TextEditingController medicinesController = TextEditingController(text: 'Neurofenix');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
              return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Header
                Text(
                  'Log Period',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                
                // Start Date
                Text(
                  'Start date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDialog<DateTime>(
                      context: context,
                      builder: (context) => CustomDatePicker(
                        initialDate: startDate ?? DateTime.now(),
                      ),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        startDate = selectedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate != null 
                            ? '${startDate!.day} ${_getMonthName(startDate!.month)} ${startDate!.year}'
                            : '6 May 2028',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // End Date
                Text(
                  'End Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDialog<DateTime>(
                      context: context,
                      builder: (context) => CustomDatePicker(
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: startDate, // Ensure end date is after start date
                      ),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        endDate = selectedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endDate != null 
                            ? '${endDate!.day} ${_getMonthName(endDate!.month)} ${endDate!.year}'
                            : '10 May 2028',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // Period Flow Dropdown
                Text(
                  'Period Flow',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriodFlow,
                      isExpanded: true,
                      items: ['Light', 'Medium', 'Heavy'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedPeriodFlow = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // Additional Information Row 1
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average period duration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: avgPeriodDurationController,
                            decoration: InputDecoration(
                              hintText: 'Enter duration',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average cycle length',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: avgCycleLengthController,
                            decoration: InputDecoration(
                              hintText: 'Enter cycle length',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Additional Information Row 2
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Is your cycle regular',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: isCycleRegularController,
                            decoration: InputDecoration(
                              hintText: 'Yes/No',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medical condition',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: medicalConditionController,
                            decoration: InputDecoration(
                              hintText: 'Enter condition',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Additional Information Row 3
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Do you take any medicines',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: medicinesController,
                            decoration: InputDecoration(
                              hintText: 'Enter medicines',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()), // Empty space to balance the row
                  ],
                ),
                SizedBox(height: 20),
                
                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the add logic here
                      if (startDate != null && endDate != null) {
                        // Process the log period data
                        print('Start Date: $startDate');
                        print('End Date: $endDate');
                        print('Period Flow: $selectedPeriodFlow');
                        print('Avg Period Duration: ${avgPeriodDurationController.text}');
                        print('Avg Cycle Length: ${avgCycleLengthController.text}');
                        print('Is Cycle Regular: ${isCycleRegularController.text}');
                        print('Medical Condition: ${medicalConditionController.text}');
                        print('Medicines: ${medicinesController.text}');
                        Navigator.pop(context);
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select both start and end dates'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
            ),
          );
          
          
          

        },
         
      );
    },
  );
}

// Helper method to get month name
String _getMonthName(int month) {
  const months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month];
}

  String monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}


