import 'package:flutter/material.dart';
import 'package:ins_app/model/AddEvent.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 100,
          height: 100,
          child: Transform.scale(scale: 1.5, child: Icon(Icons.event)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              child: TableCalendar(
                calendarController: _calendarController,
                weekendDays: [6,7],
                headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 94, 6, 247),
                  ),
                  headerMargin: const EdgeInsets.only(top: 8.0),
                  titleTextStyle: TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedDate =
              _calendarController.selectedDay; // Retrieve the selected date
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEvent(selectedDate: selectedDate)),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
      ),
    );
  }
}
