import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:flutter/material.dart';

class PrescriptionPage extends StatefulWidget {
  final Future<List<Prescription>> prescription;

  const PrescriptionPage({super.key, required this.prescription});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  // Dummy data - replace with your API data
  final prescription = {
    "id": 1,
    "date_prescribed": "2025-04-11T13:07:07.418491Z",
    "instructions": "Take to the end",
    "diagnosis": 1,
    "prescribed_by": 2,
    "prescribed_to": 3,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescription")),
      body: FutureBuilder<List<Prescription>>(
        future: widget.prescription,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No prescriptions found.'));
          }

          final prescriptions = snapshot.data!;

          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D557F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor name and image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Dr. Evin Masi",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.person, size: 30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      infoRow("Prescription ID", prescription.id.toString()),
                      const SizedBox(height: 10),
                      infoRow(
                        "Date",
                        prescription.datePrescribed.split('T')[0],
                      ),
                      const SizedBox(height: 10),
                      infoRow("Instructions", prescription.instructions),
                      const SizedBox(height: 10),
                      infoRow(
                        "Diagnosis ID",
                        prescription.diagnosisId.toString(),
                      ),
                      const SizedBox(height: 10),
                      infoRow(
                        "Prescribed To (User ID)",
                        prescription.prescribedTo.toString(),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MedicationsPage1(
                                    prescriptionId: prescription.id,
                                  ),
                            ),
                          );
                        },
                        child: const Text("View Medications"),
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

  Widget infoRow(String title, String value) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class MedicationsPage1 extends StatelessWidget {
  final int prescriptionId;

  const MedicationsPage1({super.key, required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    // Dummy Medications Page
    return Scaffold(
      appBar: AppBar(title: const Text("Medications")),
      body: Center(
        child: Text("Medications for Prescription ID: $prescriptionId"),
      ),
    );
  }
}
