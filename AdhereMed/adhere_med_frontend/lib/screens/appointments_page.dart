import 'package:adhere_med_frontend/models/appointment_model.dart';
import 'package:adhere_med_frontend/services/appointment_services.dart';
import 'package:flutter/material.dart';
import '../components/custom_input_field.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController modeController = TextEditingController();

  late AppointmentService appointmentService;
  List<Appointment> appointments = [];

  final int currentUserId = 1; // Replace with logged-in user ID
  int selectedDoctorId = 1; // Will update dynamically
  final Map<String, int> doctors = {
    "Dr. John Doe": 1,
    "Dr. Smith": 2,
    "Dr. Jane": 3,
  };

  @override
  void initState() {
    super.initState();
    appointmentService = AppointmentService(); // Replace with real token
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final data = await appointmentService.getAppointments();
      setState(() {
        appointments = data;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<void> createNewAppointment() async {
    try {
      final dateTime = DateTime.parse(dateTimeController.text);
      final appointment = Appointment(
        id: 0,
        date: dateTime.toIso8601String().split("T")[0],
        time: dateTime.toIso8601String().split("T")[1].substring(0, 8),
        reason: modeController.text,
        status: 'pending',
        createdAt: '',
        patient: currentUserId,
        doctor: selectedDoctorId,
      );
      await appointmentService.createAppointment(appointment);
      fetchAppointments();
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color primaryBlue = const Color(0xFF0D557F);
    Color lightCard = isDark ? Colors.grey[900]! : Colors.grey[100]!;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              "Appointment",
              alignment: MainAxisAlignment.end,
              primary: primaryBlue,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CustomTextField(
                    controller: dateTimeController,
                    hintText: "Select date and time",
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final fullDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          dateTimeController.text = fullDateTime.toString();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: doctorController,
                    hintText: "Select doctor",
                    onTap: () async {
                      final selected = await showDialog<String>(
                        context: context,
                        builder:
                            (context) => SimpleDialog(
                              title: const Text("Select Doctor"),
                              children:
                                  doctors.keys
                                      .map(
                                        (doctor) => SimpleDialogOption(
                                          child: Text(doctor),
                                          onPressed:
                                              () => Navigator.pop(
                                                context,
                                                doctor,
                                              ),
                                        ),
                                      )
                                      .toList(),
                            ),
                      );
                      if (selected != null) {
                        doctorController.text = selected;
                        selectedDoctorId = doctors[selected]!;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: modeController,
                    hintText: "Select mode",
                    onTap: () async {
                      final modes = ["Physical", "Virtual", "Phone Call"];
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        builder:
                            (context) => ListView(
                              children:
                                  modes
                                      .map(
                                        (mode) => ListTile(
                                          title: Text(mode),
                                          onTap:
                                              () =>
                                                  Navigator.pop(context, mode),
                                        ),
                                      )
                                      .toList(),
                            ),
                      );
                      if (selected != null) {
                        modeController.text = selected;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (dateTimeController.text.isNotEmpty &&
                            doctorController.text.isNotEmpty &&
                            modeController.text.isNotEmpty) {
                          createNewAppointment();
                        }
                      },
                      child: const Text(
                        "Schedule Appointment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            _sectionHeader(
              "Upcoming Appointment",
              alignment: MainAxisAlignment.start,
              primary: primaryBlue,
            ),
            const SizedBox(height: 20),

            Container(
              height: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  appointments.isEmpty
                      ? Center(
                        child: Text(
                          "No upcoming appointments.",
                          style: TextStyle(color: textColor.withOpacity(0.6)),
                        ),
                      )
                      : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appointments.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Container(
                            width: 180,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Doctor ID: ${appointment.doctor}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Date: ${appointment.date}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Time: ${appointment.time}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Mode: ${appointment.reason ?? 'Not set'}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Status: ${appointment.status}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    String text, {
    required MainAxisAlignment alignment,
    required Color primary,
  }) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
