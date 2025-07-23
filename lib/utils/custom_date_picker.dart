import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Custom Calendar Date Picker with Year Selection
class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime currentMonth;
  DateTime? selectedDate;
  bool showYearPicker = false;

  @override
  void initState() {
    super.initState();
    currentMonth = widget.initialDate ?? DateTime.now();
    selectedDate = widget.initialDate;
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void _toggleYearPicker() {
    setState(() {
      showYearPicker = !showYearPicker;
    });
  }

  void _selectYear(int year) {
    setState(() {
      currentMonth = DateTime(year, currentMonth.month);
      showYearPicker = false;
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    
    final firstDayWeekday = firstDayOfMonth.weekday % 7; // Make Sunday = 0
    final daysFromPreviousMonth = firstDayWeekday;
    
    List<DateTime> days = [];
    
    // Add days from previous month
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    final lastDayOfPreviousMonth = DateTime(previousMonth.year, previousMonth.month + 1, 0);
    
    for (int i = daysFromPreviousMonth - 1; i >= 0; i--) {
      days.add(DateTime(previousMonth.year, previousMonth.month, lastDayOfPreviousMonth.day - i));
    }
    
    // Add days from current month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, day));
    }
    
    // Add days from next month to complete the grid
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    int nextMonthDays = 1;
    while (days.length < 42) { // 6 rows * 7 days
      days.add(DateTime(nextMonth.year, nextMonth.month, nextMonthDays));
      nextMonthDays++;
    }
    
    return days;
  }

  List<int> _getYearRange() {
    final now = DateTime.now();
    final startYear = widget.firstDate?.year ?? (now.year - 50);
    final endYear = widget.lastDate?.year ?? (now.year + 50);
    
    List<int> years = [];
    for (int year = startYear; year <= endYear; year++) {
      years.add(year);
    }
    return years;
  }

  Widget _buildYearPicker() {
    final years = _getYearRange();
    final selectedYear = currentMonth.year;
    
    // Calculate year range display
    final startYear = years.first;
    final endYear = years.last;
    
    return Container(
      width: 320,
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _toggleYearPicker,
                child: Row(
                  children: [
                    Text(
                      '$startYear - $endYear',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_up, color: Colors.black87),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigate to previous year range if needed
                    },
                    icon: const Icon(Icons.chevron_left, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to next year range if needed
                    },
                    icon: const Icon(Icons.chevron_right, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Year grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = year == selectedYear;
                
                return GestureDetector(
                  onTap: () => _selectYear(year),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade400 : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('CANCEL'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _toggleYearPicker(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == currentMonth.month && date.year == currentMonth.year;
  }

  bool _isSelected(DateTime date) {
    if (selectedDate == null) return false;
    return date.year == selectedDate!.year &&
           date.month == selectedDate!.month &&
           date.day == selectedDate!.day;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
           date.month == today.month &&
           date.day == today.day;
  }

  Widget _buildCalendarView() {
    final days = _getDaysInMonth();
    
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with month/year and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _toggleYearPicker,
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMM yyyy').format(currentMonth).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Days of week header
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Container(
                  height: 32,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 8),
          
          // Calendar grid
          SizedBox(
            height: 240, // 6 rows * 40 height
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth = _isCurrentMonth(date);
                final isSelected = _isSelected(date);
                final isToday = _isToday(date);
                
                return GestureDetector(
                  onTap: () {
                    if (isCurrentMonth) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Colors.black87
                        : isToday 
                          ? Colors.grey.shade200
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(2),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                          ? Colors.white
                          : isCurrentMonth
                            ? Colors.black87
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('CANCEL'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: selectedDate != null 
                  ? () => Navigator.of(context).pop(selectedDate)
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: showYearPicker ? _buildYearPicker() : _buildCalendarView(),
    );
  }
}