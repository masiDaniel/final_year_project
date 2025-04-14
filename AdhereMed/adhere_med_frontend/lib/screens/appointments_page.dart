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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF85A9BD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Appointment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                      doctors.keys.map((doctor) {
                                        return SimpleDialogOption(
                                          child: Text(doctor),
                                          onPressed:
                                              () => Navigator.pop(
                                                context,
                                                doctor,
                                              ),
                                        );
                                      }).toList(),
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
                                      modes.map((mode) {
                                        return ListTile(
                                          title: Text(mode),
                                          onTap:
                                              () =>
                                                  Navigator.pop(context, mode),
                                        );
                                      }).toList(),
                                ),
                          );
                          if (selected != null) {
                            modeController.text = selected;
                          }
                        },
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (dateTimeController.text.isNotEmpty &&
                                  doctorController.text.isNotEmpty &&
                                  modeController.text.isNotEmpty) {
                                createNewAppointment();
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 170,
                              decoration: BoxDecoration(
                                color: const Color(0xFF85A9BD),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Schedule appointment",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 170,
                    decoration: BoxDecoration(
                      color: const Color(0xFF85A9BD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Upcoming appointment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        appointments.map((appointment) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              height: 250,
                              width: 170,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Doctor ID: ${appointment.doctor}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Date: ${appointment.date}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Time: ${appointment.time}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Mode: ${appointment.reason ?? 'Not set'}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Status: ${appointment.status}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
