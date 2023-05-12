import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  static String routeName = '_booking';
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        onDateChanged: (value) => print(value),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        locale: 'es_ES',
        fullCalendar: false,
      ),
    );
  }
}
