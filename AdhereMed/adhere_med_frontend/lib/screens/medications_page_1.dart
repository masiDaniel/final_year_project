import 'dart:convert';

import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/medication_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/screens/medication_picker.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicationsPage1 extends StatefulWidget {
  final int prescriptionId;
  final Future<List<PrescriptionMedication>> prescribedMedications;

  const MedicationsPage1({
    super.key,
    required this.prescriptionId,
    required this.prescribedMedications,
  });

  @override
  State<MedicationsPage1> createState() => _MedicationsPage1State();
}

class _MedicationsPage1State extends State<MedicationsPage1> {
  Medication? selectedMedication;

  void _pickMedication() async {
    final med = await showMedicationPicker(context);
    if (med != null) {
      setState(() {
        selectedMedication = med;
      });
    }
  }

  void _showAddMedicationDialog() {
    final dosageController = TextEditingController();
    final frequencyController = TextEditingController();
    final durationController = TextEditingController();
    final medicationIdController = TextEditingController();

    bool morning = false;
    bool afternoon = false;
    bool evening = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Medication'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(labelText: 'Dosage'),
                    ),
                    TextField(
                      controller: frequencyController,
                      decoration: const InputDecoration(labelText: 'Frequency'),
                    ),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (in days)',
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    Text(
                      selectedMedication != null
                          ? selectedMedication!.name!
                          : "No medication selected",
                    ),
                    ElevatedButton(
                      onPressed: _pickMedication,
                      child: Text("Choose Medication"),
                    ),
                    CheckboxListTile(
                      title: const Text('Morning'),
                      value: morning,
                      onChanged: (value) {
                        setState(() => morning = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Afternoon'),
                      value: afternoon,
                      onChanged: (value) {
                        setState(() => afternoon = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Evening'),
                      value: evening,
                      onChanged: (value) {
                        setState(() => evening = value ?? false);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _addMedication(
                      dosage: dosageController.text,
                      frequency: frequencyController.text,
                      duration: int.tryParse(durationController.text) ?? 0,
                      medicationId:
                          int.tryParse(medicationIdController.text) ?? 0,
                      morning: morning,
                      afternoon: afternoon,
                      evening: evening,
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addMedication({
    required String dosage,
    required String frequency,
    required int duration,
    required int medicationId,
    bool morning = false,
    bool afternoon = false,
    bool evening = false,
  }) async {
    final url = Uri.parse(
      '$base_url/medication/prescriptions/',
    ); // change accordingly
    final token = await TokenService.getAccessToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "dosage": dosage,
        "frequency": frequency,
        "duration": duration,
        "prescription": widget.prescriptionId,
        "medication": medicationId,
        if (morning) "morning": "True",
        if (afternoon) "afternoon": "True",
        if (evening) "evening": "True",
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        // widget.prescribedMedications =
        //     fetchUpdatedMedications(); // You'll need to implement this
      });
    } else {
      print('Failed to add medication: ${response.body}');
    }
  }

  Future<Medication?> showMedicationPicker(BuildContext context) async {
    return showDialog<Medication>(
      context: context,
      builder: (context) {
        return MedicationPickerDialog();
      },
    );
  }

  // Future<List<PrescriptionMedication>> fetchUpdatedMedications() {
  //   // Replace with your actual API fetch logic
  //   return MedicationService.getPrescribedMedications(widget.prescriptionId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medications")),
      body: FutureBuilder<List<PrescriptionMedication>>(
        future: widget.prescribedMedications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No medications found."));
          }

          final medications = snapshot.data!;

          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final med = medications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // title: Text("Medication: ${med.id.toString()}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dosage: ${med.dosage}"),
                      Text("Frequency: ${med.frequency}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
