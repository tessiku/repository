import 'package:flutter/material.dart';
import 'package:ins_app/model/AddEvent.dart';
import 'package:table_calendar/table_calendar.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({Key? key}) : super(key: key);

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeletePage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              child: TableCalendar(
                calendarController: _calendarController,
                weekendDays: [6],
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
