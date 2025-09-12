import 'package:flutter/material.dart';

class SelectedDayProvider extends ChangeNotifier {
  late int _selectedDay;

  // Constructor to set initial day
  SelectedDayProvider({int initialDay = 1}) {
    _selectedDay = initialDay;
  }

  int get selectedDay => _selectedDay;

  void setDay(int day) {
    _selectedDay = day;
    notifyListeners(); // notify all listeners
  }
}
