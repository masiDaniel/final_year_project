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
  void _addEvent(
    DateTime day,
    String title,
    String description,
    String location,
    DateTime startTime,
    DateTime endTime,
    Color color,
  ) {
    final normalizedDay = _normalizeDate(day);
    if (_events[normalizedDay] == null) {
      _events[normalizedDay] = [];
    }
    _events[normalizedDay]!.add(
      Event(
        title: title,
        description: description,
        color: color,
        startTime: startTime,
        endTime: endTime,
        location: location,
      ),
    );
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
      // Open dialog to add the event
      await _showEventDetailsDialog(selectedDate);
    }
  }

  // Show a dialog to enter the event details including appointment time and location
  Future<String?> _showEventDetailsDialog(DateTime selectedDate) async {
    TextEditingController eventTitleController = TextEditingController();
    TextEditingController eventDescriptionController = TextEditingController();
    TextEditingController eventLocationController = TextEditingController();
    DateTime? startTime;
    DateTime? endTime;

    // DateTime pickers for start and end times
    Future<void> _pickTime(BuildContext context, bool isStartTime) async {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        DateTime selected = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute,
        );
        if (isStartTime) {
          startTime = selected;
        } else {
          endTime = selected;
        }
      }
    }

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Event Details'),
          content: Column(
            children: [
              TextField(
                controller: eventTitleController,
                decoration: InputDecoration(hintText: 'Event title'),
              ),
              TextField(
                controller: eventDescriptionController,
                decoration: InputDecoration(hintText: 'Event description'),
              ),
              TextField(
                controller: eventLocationController,
                decoration: InputDecoration(hintText: 'Location'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickTime(context, true),
                    child: Text('Pick Start Time'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickTime(context, false),
                    child: Text('Pick End Time'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventTitleController.text.isNotEmpty &&
                    startTime != null &&
                    endTime != null) {
                  // Add event with all details
                  _addEvent(
                    selectedDate,
                    eventTitleController.text,
                    eventDescriptionController.text,
                    eventLocationController.text,
                    startTime!,
                    endTime!,
                    Colors.blue,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
                              subtitle: Text(
                                'Time: ${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}\n'
                                'Location: ${event.location}\n'
                                'Description: ${event.description}',
                              ),
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
                _selectDateAndAddEvent();
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
  final String description;
  final Color color;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  Event({
    required this.title,
    required this.description,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.location,
  });
}
