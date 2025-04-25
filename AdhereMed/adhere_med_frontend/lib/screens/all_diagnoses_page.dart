import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/add_prescrition_page.dart';
import 'package:adhere_med_frontend/screens/prescription_page.dart';
import 'package:adhere_med_frontend/services/diagnosis_service.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiagnosisListPage extends StatefulWidget {
  const DiagnosisListPage({super.key});

  @override
  State<DiagnosisListPage> createState() => _DiagnosisListPageState();
}

class _DiagnosisListPageState extends State<DiagnosisListPage> {
  late Future<List<Diagnosis>> _diagnosesFuture;
  late Future<List<Prescription>> _prescriptions;

  @override
  void initState() {
    super.initState();
    _diagnosesFuture = DiagnosisService().fetchDiagnoses();

    _prescriptions = PrescriptionService().fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Diagnoses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([_diagnosesFuture, _prescriptions]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final diagnoses = snapshot.data![0] as List<Diagnosis>;
            final prescriptions = snapshot.data![1] as List<Prescription>;

            if (diagnoses.isEmpty) {
              return const Center(child: Text('No diagnoses found.'));
            }

            return ListView.separated(
              itemCount: diagnoses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final diagnosis = diagnoses[index];
                final relatedPrescriptions =
                    prescriptions
                        .where((p) => p.diagnosisId == diagnosis.id)
                        .toList();

                final hasPrescription = relatedPrescriptions.isNotEmpty;

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
                        Text(
                          "Diagnosed on: ${DateFormat.yMMMMd().format(DateTime.parse(diagnosis.dateDiagnosed!))}",
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (hasPrescription) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PrescriptionPage(
                                      prescription: Future.value(
                                        relatedPrescriptions,
                                      ),
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddPrescriptionPage(
                                      diagnosis: diagnosis.id,
                                      prescribed_by: diagnosis.doctorId,
                                      prescribed_to: diagnosis.patientId,
                                    ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          hasPrescription
                              ? "View Prescription"
                              : "Add Prescription",
                        ),
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
