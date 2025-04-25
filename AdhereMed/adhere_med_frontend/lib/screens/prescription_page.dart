import 'dart:convert';

import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/doctors_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/medications_page_1.dart';
import 'package:adhere_med_frontend/services/doctors_service.dart';
import 'package:adhere_med_frontend/services/medication_service.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrescriptionPage extends StatefulWidget {
  final Future<List<Prescription>> prescription;

  const PrescriptionPage({super.key, required this.prescription});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  late Future<List<PrescriptionMedication>> _prescribedMedications;
  late Future<List<Doctor>> _doctors;
  List<Doctor> _allDoctors = [];

  @override
  void initState() {
    super.initState();
    _prescribedMedications = PrescriptionMedicationService.fetchAll();
    _doctors = DoctorService().getDoctors();
    _doctors.then((data) {
      setState(() {
        _allDoctors = data;
      });
    });
  }

  String getDoctorNameById(int doctorId) {
    DateTime defaultDate = DateTime.now();
    // Assuming _allDoctors is a list of Doctor objects
    final doctor = _allDoctors.firstWhere(
      (doc) => doc.id == doctorId,
      orElse:
          () => Doctor(
            id: doctorId,
            licenseNo: 'N/A',
            userId: -1,
            userDetails: UserDetails(
              id: -1,
              username: 'unknown',
              firstName: 'Unknown',
              lastName: 'Doctor',
              email: 'unknown@example.com',
              profilePic: '',
              phoneNumber: '',
              userType: 'doctor',
              isActive: false,
              isSuperuser: false,
              dateJoined: defaultDate,
              // Add default values for other required fields...
            ),
          ),
    );

    // Combine first and last names
    return '${doctor.userDetails.firstName} ${doctor.userDetails.lastName}';
  }

  String getDoctorProfileById(int doctorId) {
    DateTime defaultDate = DateTime.now();
    // Assuming _allDoctors is a list of Doctor objects
    final doctor = _allDoctors.firstWhere(
      (doc) => doc.id == doctorId,
      orElse:
          () => Doctor(
            id: doctorId,
            licenseNo: 'N/A',
            userId: -1,
            userDetails: UserDetails(
              id: -1,
              username: 'unknown',
              firstName: 'Unknown',
              lastName: 'Doctor',
              email: 'unknown@example.com',
              profilePic: '',
              phoneNumber: '',
              userType: 'doctor',
              isActive: false,
              isSuperuser: false,
              dateJoined: defaultDate,
              // Add default values for other required fields...
            ),
          ),
    );

    // Combine first and last names
    return '${doctor.userDetails.profilePic}';
  }

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
                padding: const EdgeInsets.all(8.0),
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
                          Text(
                            "Dr.  ${getDoctorNameById(prescription.prescribedBy)}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                '$base_url${getDoctorProfileById(prescription.prescribedBy)}', // complete this with actual path
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey,
                                  );
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      infoRow(
                        "Date",
                        prescription.datePrescribed.split('T')[0],
                      ),
                      const SizedBox(height: 10),
                      infoRow("Instructions", prescription.instructions),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final filteredMeds = _prescribedMedications.then(
                            (meds) =>
                                meds
                                    .where(
                                      (med) =>
                                          med.prescription == prescription.id,
                                    )
                                    .toList(),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MedicationsPage1(
                                    prescriptionId: prescription.id,
                                    prescribedMedications: filteredMeds,
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
