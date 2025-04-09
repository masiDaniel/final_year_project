import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController modeController = TextEditingController();
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
                        hintText: "select doctor",
                        onTap: () async {
                          final doctors = [
                            "Dr. John Doe",
                            "Dr. Smith",
                            "Dr. Jane",
                          ];
                          final selected = await showDialog<String>(
                            context: context,
                            builder:
                                (context) => SimpleDialog(
                                  title: Text("Select Doctor"),
                                  children:
                                      doctors.map((doctor) {
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
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: modeController,
                        hintText: "select mode",
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

                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                "Schedule appointment",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 50),

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

              SizedBox(height: 20),

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
                    children: [
                      Container(
                        height: 250,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text("prescription 1"),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 250,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text("prescription 1"),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 250,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text("prescription 1"),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 250,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text("prescription 1"),
                      ),
                    ],
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
