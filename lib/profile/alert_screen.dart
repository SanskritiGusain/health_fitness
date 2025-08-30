import 'package:flutter/material.dart';

class Alert {
  final String title;
  final String subtitle;
  final String icon;
  bool isEnabled;

  Alert({
    required this.title,
    required this.subtitle,
    this.icon = ' ',
    this.isEnabled = false,
  });
}

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Alert> alerts = [
    Alert(
      title: 'Daily goal',
      subtitle: 'Daily 09:00am ',
      icon: "icon.edit",
      isEnabled: false,
    ),
    Alert(
      title: 'Water',
      subtitle: 'Daily 09:00am',
      icon: "con.edit",
      isEnabled: true,
    ),
    Alert(
      title: 'Weight',
      subtitle: 'Weekly 09:00am ',
      icon: "icon.edit",
      isEnabled: false,
    ),
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
              alerts.add(
                Alert(
                  title: title,
                  subtitle: '$frequency $time ',
                  isEnabled: true,
                ),
              );
            });
          },
        );
      },
    );
  }

  void _showEditAlertModal(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditAlertModal(
          alert: alerts[index],
          onAlertUpdated: (String title, String frequency, String time) {
            setState(() {
              alerts[index] = Alert(
                title: title,
                subtitle: '$frequency $time ',
                isEnabled: alerts[index].isEnabled,
              );
            });
          },
          onAlertDeleted: () {
            setState(() {
              alerts.removeAt(index);
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Alert',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
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
                Icon(Icons.add, color: Colors.black, size: 22),
                SizedBox(width: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showEditAlertModal(index),
            child: Container(
              margin: EdgeInsets.only(bottom: 18),
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
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
                        Row(
                          children: [
                            Text(
                              alerts[index].subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: () => _showEditAlertModal(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: alerts[index].isEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          alerts[index].isEnabled = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey[300],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
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
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '${hour.toString().padLeft(2, '0')}:$minute$period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar with better styling
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header with better spacing
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Alert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey[200], height: 1, thickness: 1),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input field with better styling
                  Text(
                    'Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                 TextField(
                    controller: _reminderController,
                    decoration: InputDecoration(
                      hintText: 'Enter reminder name...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 14),
                  ),

                  SizedBox(height: 20),

                  // Frequency selector with better styling
                  Text(
                    'Frequency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFrequency,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                        ),
                        items:
                            _frequencies.map((String frequency) {
                              return DropdownMenuItem<String>(
                                value: frequency,
                                child: Text(
                                  frequency,
                                  style: TextStyle(fontSize: 16),
                                ),
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

                  SizedBox(height: 20),

                  // Time selector with better styling
                  Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_selectedTime),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Add button with better styling
                  Container(
                    width: double.infinity,
                    height: 50,
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
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Add Alert',
                        style: TextStyle(
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

class EditAlertModal extends StatefulWidget {
  final Alert alert;
  final Function(String, String, String) onAlertUpdated;
  final Function() onAlertDeleted;

  EditAlertModal({
    required this.alert,
    required this.onAlertUpdated,
    required this.onAlertDeleted,
  });

  @override
  _EditAlertModalState createState() => _EditAlertModalState();
}

class _EditAlertModalState extends State<EditAlertModal> {
  late TextEditingController _reminderController;
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    _reminderController = TextEditingController(text: widget.alert.title);
    _parseExistingAlert();
  }

  void _parseExistingAlert() {
    String subtitle = widget.alert.subtitle;
    if (subtitle.contains('Daily')) {
      _selectedFrequency = 'Daily';
    } else if (subtitle.contains('Weekly')) {
      _selectedFrequency = 'Weekly';
    } else if (subtitle.contains('Monthly')) {
      _selectedFrequency = 'Monthly';
    }

    RegExp timeRegExp = RegExp(r'(\d{1,2}):(\d{2})(am|pm)');
    Match? match = timeRegExp.firstMatch(subtitle);
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      if (period == 'pm' && hour != 12) hour += 12;
      if (period == 'am' && hour == 12) hour = 0;

      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    }
  }

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
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '${hour.toString().padLeft(2, '0')}:$minute$period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar with better styling
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header with better spacing
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Alert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey[200], height: 1, thickness: 1),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input field with better styling
                  Text(
                    'Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
            
                    
                   TextField(
                      controller: _reminderController,
                      decoration: InputDecoration(
                        hintText: 'Enter reminder name...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
              

                  SizedBox(height: 20),

                  // Frequency selector with better styling
                  Text(
                    'Frequency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFrequency,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                        ),
                        items:
                            _frequencies.map((String frequency) {
                              return DropdownMenuItem<String>(
                                value: frequency,
                                child: Text(
                                  frequency,
                                  style: TextStyle(fontSize: 16),
                                ),
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

                  SizedBox(height: 20),

                  // Time selector with better styling
                  Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_selectedTime),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Button row with better styling
                 
                    

                      // Update button
                      Expanded(
                      
                        child: Container(
                         
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_reminderController.text.isNotEmpty) {
                                widget.onAlertUpdated(
                                  _reminderController.text,
                                  _selectedFrequency,
                                  _formatTime(_selectedTime),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 3),
                            ),
                            child: Text(
                              'Update Alert',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
