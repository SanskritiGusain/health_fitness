import 'package:flutter/material.dart';

class SelectedWeekDayProvider with ChangeNotifier {
  String _selectedWeekDay = '';

  String get selectedWeekDay => _selectedWeekDay;

  void setDefaultWeekDay(DateTime createdAt, int selectedDay) {
    final weekdayIndex = (createdAt.weekday + selectedDay - 2) % 7; // 0..6
    const weekdayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    _selectedWeekDay = weekdayNames[weekdayIndex];
    notifyListeners();
  }

  void setWeekDay(String weekDay) {
    _selectedWeekDay = weekDay;
    notifyListeners();
  }
}

