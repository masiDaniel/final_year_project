import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/services/prescription_service.dart';
import 'package:flutter/material.dart';

class MedicationList extends StatefulWidget {
  const MedicationList({Key? key}) : super(key: key);

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  late Future<List<PrescriptionMedication>> _medications;

  @override
  void initState() {
    super.initState();
    _medications = PrescriptionMedicationService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: FutureBuilder<List<PrescriptionMedication>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final meds = snapshot.data!;
          return ListView.builder(
            itemCount: meds.length,
            itemBuilder: (context, index) {
              final med = meds[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Dosage: ${med.dosage}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Frequency: ${med.frequency}"),
                      Text("Duration: ${med.duration} days"),
                      if (med.instructions != null)
                        Text("Instructions: ${med.instructions}"),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (med.morning) const Chip(label: Text("Morning")),
                          if (med.afternoon)
                            const Chip(label: Text("Afternoon")),
                          if (med.evening) const Chip(label: Text("Evening")),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
