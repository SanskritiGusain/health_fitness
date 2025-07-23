import 'package:flutter/material.dart';




class Alert {
  final String title;
  final String subtitle;
  bool isEnabled;

  Alert({required this.title, required this.subtitle, this.isEnabled = false});
}

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Alert> alerts = [
    Alert(title: 'Daily goal', subtitle: 'Get 50 Point', isEnabled: false),
    Alert(title: 'Water', subtitle: 'Get 10 Point', isEnabled: true),
    Alert(title: 'Weight', subtitle: 'Get 10 Point', isEnabled: false),
  ];

  void _showAddAlertModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddAlertModal(
          onAlertAdded: (String title, String frequency, String time) {
            setState(() {
              alerts.add(Alert(
                title: title,
                subtitle: '$frequency at $time',
                isEnabled: true,
              ));
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Alert',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _showAddAlertModal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.green, size: 18),
                SizedBox(width: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alerts[index].title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        alerts[index].subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: alerts[index].isEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      alerts[index].isEnabled = value;
                    });
                  },
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green[200],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddAlertModal extends StatefulWidget {
  final Function(String, String, String) onAlertAdded;

  AddAlertModal({required this.onAlertAdded});

  @override
  _AddAlertModalState createState() => _AddAlertModalState();
}

class _AddAlertModalState extends State<AddAlertModal> {
  final TextEditingController _reminderController = TextEditingController();
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute${time.period == DayPeriod.am ? 'am' : 'pm'}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Add Alert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type reminder input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _reminderController,
                      decoration: InputDecoration(
                        hintText: 'Type reminder...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Set frequency dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFrequency,
                        isExpanded: true,
                        hint: Text(
                          'Set frequency',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        items: _frequencies.map((String frequency) {
                          return DropdownMenuItem<String>(
                            value: frequency,
                            child: Text(frequency),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFrequency = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Set time
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_selectedTime),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.access_time, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                  
                  Spacer(),

                  // Add button
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_reminderController.text.isNotEmpty) {
                          widget.onAlertAdded(
                            _reminderController.text,
                            _selectedFrequency,
                            _formatTime(_selectedTime),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reminderController.dispose();
    super.dispose();
  }
}