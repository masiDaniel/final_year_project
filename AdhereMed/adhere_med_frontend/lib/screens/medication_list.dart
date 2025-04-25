import 'package:adhere_med_frontend/models/medication_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/services/medication_service.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:flutter/material.dart';

class MedicationList extends StatefulWidget {
  const MedicationList({Key? key}) : super(key: key);

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  late Future<List<PrescriptionMedication>> _medications;
  late List<Medication> medicationsList = [];
  bool loading = true;

  Future<void> _fetchMedications() async {
    try {
      List<Medication> fetchedMedications =
          await MedicationService().getMedication();
      setState(() {
        medicationsList = fetchedMedications;
        loading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      setState(() {
        loading = false; // Set loading to false in case of an error
      });
      print("Error fetching medications: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _medications = PrescriptionMedicationService.fetchAll();
    _fetchMedications();
  }

  String getMedicationNameById(int medicationId) {
    // Assuming _medications is populated with a list of Medication objects
    List<Medication> medications = medicationsList;
    print('these are the medications $medications');
    print('this is the id $medicationId');

    // Find the medication that matches the given ID
    final medication = medications.firstWhere(
      (medication) => medication.id == medicationId,
      orElse:
          () => Medication(
            id: medicationId, // The ID you are looking for
            name: 'Medication Name', // Name of the medication
            genericName: 'Generic Name', // Optional: Generic Name
            brandName: 'Brand Name', // Optional: Brand Name
            description:
                'This is a description of the medication', // Description is required
            dosageForm: 'Tablet', // Dosage form is required
            strength: '500mg', // Strength is required
            routeOfAdministration:
                'Oral', // Route of administration is required
            sideEffects: 'Nausea, dizziness', // Side effects are required
            interactions:
                'May interact with alcohol', // Drug interactions are required
            contraindications:
                'Not recommended for pregnant women', // Contraindications are required
            manufacturer: 'PharmaCorp', // Optional: Manufacturer
            approvalDate: '2021-01-01', // Required: Approval date
            expiryDate: '2023-01-01', // Required: Expiry date
            requiresPrescription: true, // Required: Prescription needed
            stockQuantity: 100, // Required: Stock quantity
            price: '50.00', // Required: Price
            createdAt: '2021-01-01', // Required: Created date
            updatedAt: '2021-12-01', // Required: Updated date
          ), // Default value if no match
    );

    return medication.name!;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D557F); // App's primary color
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: isDark ? Colors.grey[850] : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.medication, color: primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Dosage: ${med.dosage}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "Name: ${getMedicationNameById(med.medication)}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),

                      Text(
                        "Duration: ${med.duration} days",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      if (med.instructions != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Instructions: ${med.instructions}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (med.morning)
                            Chip(
                              label: const Text("Morning"),
                              backgroundColor: primaryColor.withOpacity(0.2),
                              labelStyle: TextStyle(color: primaryColor),
                            ),
                          if (med.afternoon)
                            Chip(
                              label: const Text("Afternoon"),
                              backgroundColor: primaryColor.withOpacity(0.2),
                              labelStyle: TextStyle(color: primaryColor),
                            ),
                          if (med.evening)
                            Chip(
                              label: const Text("Evening"),
                              backgroundColor: primaryColor.withOpacity(0.2),
                              labelStyle: TextStyle(color: primaryColor),
                            ),
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
