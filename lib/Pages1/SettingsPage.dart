import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ins_app/model/AddEvent.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Appointment> _appointments = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar Page')),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: AppointmentDataSource(_appointments),
        blackoutDates: getDisabledDates(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _addAppointment(details.date!);
          }
        },
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 2,
        ),
      ),
    );
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
