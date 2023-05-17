import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ins_app/model/AddEvent.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Appointment> _appointments = [];
  List<Appointment> _selectedAppointments = [];
  CalendarController _calendarController = CalendarController();

  void _addAppointment(DateTime selectedDate) async {
    final newAppointment = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEvent(
                selectedDate: selectedDate,
                eventName: '',
              )),
    );
    if (newAppointment != null) {
      setState(() {
        _appointments.add(newAppointment);
        _selectedAppointments.add(newAppointment);
      });
    }
  }

  List<DateTime> getDisabledDates() {
    List<DateTime> disabledDates = [];
    for (var appointment in _appointments) {
      if (appointment.startTime.year == DateTime.now().year &&
          appointment.startTime.month == DateTime.now().month &&
          appointment.startTime.day == DateTime.now().day) {
        // If the appointment is for today, don't disable it
        continue;
      }
      disabledDates.add(appointment.startTime);
    }
    return disabledDates;
  }

  void _showEventDetails(Appointment appointment) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date: ${dateFormat.format(appointment.startTime)}'),
              Text('Time: ${timeFormat.format(appointment.startTime)}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllEvents() {
    setState(() {
      _appointments.clear();
      _selectedAppointments.clear();
    });
  }

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
            child: Transform.scale(
              scale: 1.5,
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _deleteAllEvents,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: AppointmentDataSource(_appointments),
                blackoutDates: getDisabledDates(),
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.calendarCell) {
                    _addAppointment(details.date!);
                  }
                },
                monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  appointmentDisplayCount: 2,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _selectedAppointments.map((appointment) {
                    return GestureDetector(
                      onTap: () => _showEventDetails(appointment),
                      child: Card(
                        color: Colors.lightBlueAccent,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appointment.subject),
                              SizedBox(height: 8),
                              Text(
                                  'Date: ${appointment.startTime.year}-${appointment.startTime.month}-${appointment.startTime.day}'),
                              Text(
                                  'Hour: ${appointment.startTime.hour}:${appointment.startTime.minute}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ));
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }
}
