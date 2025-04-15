import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/prescription_page.dart';
import 'package:adhere_med_frontend/services/diagnosis_service.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:flutter/material.dart';

class DiagnosisListPage extends StatefulWidget {
  const DiagnosisListPage({super.key});

  @override
  State<DiagnosisListPage> createState() => _DiagnosisListPageState();
}

class _DiagnosisListPageState extends State<DiagnosisListPage> {
  late Future<List<Diagnosis>> _diagnosesFuture;
  late Future<List<Prescription>> _prescriptions;
  late Future<List<PrescriptionMedication>> _prescribedMedications;

  @override
  void initState() {
    super.initState();
    _diagnosesFuture = DiagnosisService().fetchDiagnoses();
    _prescribedMedications = PrescriptionMedicationService.fetchAll();
    _prescriptions = PrescriptionService().fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Diagnoses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Diagnosis>>(
          future: _diagnosesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No diagnoses found.'));
            }

            final diagnoses = snapshot.data!;
            return ListView.separated(
              itemCount: diagnoses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final diagnosis = diagnoses[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1F5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diagnosis.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Severity: ${diagnosis.severity}"),
                      Text(
                        "Follow up: ${diagnosis.followUpRequired ? "Yes" : "No"}",
                      ),
                      Text("Notes: ${diagnosis.notes}"),
                      if (diagnosis.dateDiagnosed != null)
                        Text("Diagnosed on: ${diagnosis.dateDiagnosed}"),
                      const SizedBox(height: 12), // spacing before the button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PrescriptionPage(
                                    prescription: _prescriptions.then(
                                      (allPrescriptions) =>
                                          allPrescriptions
                                              .where(
                                                (p) =>
                                                    p.diagnosisId ==
                                                    diagnosis.id,
                                              )
                                              .toList(),
                                    ),
                                  ),
                            ),
                          );
                        },
                        child: const Text("View Prescription"),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
