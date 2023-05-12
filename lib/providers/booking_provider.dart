import 'package:flutter/cupertino.dart';

class BookingProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime(2023);

  DateTime get selectedDay => _selectedDay;

  set selectedDay(DateTime value) {
    _selectedDay = value;
    notifyListeners();
  }
}