import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late final CalendarFormat _calendarFormat;

  DateTime _focusedDay = DateTime.now(); // Initialize to today's date
  DateTime _selectedDay = DateTime.now(); // Track selected day
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  // Store events using a Map
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();

    _firstDay = DateTime.utc(2020, 1, 1);
    _lastDay = DateTime.utc(2030, 12, 31);
    _calendarFormat = CalendarFormat.month;

    _selectedEvents = ValueNotifier<List<Event>>([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Normalize date by stripping the time component
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get events for the selected day
  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _events[normalizedDay] ?? [];
  }

  // Add event to the selected day
  void _addEvent(DateTime day, String eventTitle, Color eventColor) {
    final normalizedDay = _normalizeDate(day);
    if (_events[normalizedDay] == null) {
      _events[normalizedDay] = [];
    }
    _events[normalizedDay]!.add(Event(eventTitle, eventColor));
    _selectedEvents.value = _getEventsForDay(normalizedDay);
    setState(() {});
  }

  // Show a date picker and allow the user to select a date to add an event
  Future<void> _selectDateAndAddEvent() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: _firstDay,
      lastDate: _lastDay,
    );

    if (selectedDate != null) {
      // Prompt the user to enter an event name
      String eventName = await _showEventNameDialog();
      if (eventName.isNotEmpty) {
        // Add the event to the selected date
        _addEvent(selectedDate, eventName, Colors.blue);
      }
    }
  }

  // Show a dialog to enter the event name
  Future<String> _showEventNameDialog() async {
    TextEditingController eventController = TextEditingController();
    String eventName = '';

    return await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter Event Name'),
              content: TextField(
                controller: eventController,
                decoration: InputDecoration(hintText: 'Event name'),
                onChanged: (value) {
                  eventName = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(eventController.text);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        ) ??
        ''; // Default to empty if user cancels
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Calendar')),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate:
                (day) =>
                    _normalizeDate(day) ==
                    _normalizeDate(_selectedDay), // Highlight selected day
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _selectedEvents.value = _getEventsForDay(selectedDay);
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView(
                  children:
                      value
                          .map(
                            (event) => ListTile(
                              title: Text(event.title),
                              tileColor: event.color,
                            ),
                          )
                          .toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Add event to the currently focused day
                _addEvent(_focusedDay, "New Event", Colors.blue);
              },
              child: Text("Add Event to ${_focusedDay.toLocal()}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _selectDateAndAddEvent,
              child: Text("Select Date to Add Event"),
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final Color color;

  Event(this.title, this.color);
}
