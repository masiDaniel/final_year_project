import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/services/diagnosis_service.dart';
import 'package:flutter/material.dart';

class DoctorDiagnosisPage extends StatefulWidget {
  const DoctorDiagnosisPage({super.key});

  @override
  State<DoctorDiagnosisPage> createState() => _DoctorDiagnosisPageState();
}

class _DoctorDiagnosisPageState extends State<DoctorDiagnosisPage> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController patientController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController followUpController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool followUpRequired = false;

  void submitDiagnosis() async {
    try {
      final newDiagnosis = Diagnosis(
        id: 0, // or leave null if nullable
        title: diagnosisController.text,
        description: descriptionController.text,
        patientId: int.parse(patientController.text), // fix 3rd error below
        doctorId: 1,
        severity: severityController.text,
        followUpRequired: followUpRequired,
        notes: notesController.text,
        // dateDiagnosed: will be provided by backend
      );

      final created = await DiagnosisService().createDiagnosis(newDiagnosis);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diagnosis created: ${created.title}')),
      );
    } catch (e) {
      print('Error creating diagnosis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create diagnosis')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diagnose")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                        "Create diagnosis",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              CustomTextField(
                controller: diagnosisController,
                hintText: "Diagnosis",
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: descriptionController,
                hintText: "Description",
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: patientController,
                hintText: "Patient ID",
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: severityController,
                hintText: "Severity",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Follow Up Required:'),
                  Switch(
                    value: followUpRequired,
                    onChanged: (value) {
                      setState(() {
                        followUpRequired =
                            value; // Update the value based on switch toggle
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),
              CustomTextField(controller: notesController, hintText: "Notes"),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("submit Prescription");
                      submitDiagnosis();
                    },
                    child: Container(
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF85A9BD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Submit Prescription",
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
    );
  }
}


  // List<String> selectedMedication = [];

  // // Simulated backend response
  // final List<Map<String, dynamic>> medicationsList = [
  //   {'id': 1, 'name': 'Peanuts'},
  //   {'id': 2, 'name': 'Dust'},
  //   {'id': 3, 'name': 'Pollen'},
  //   {'id': 4, 'name': 'Milk'},
  // ];

  // void _showMedicationsPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Text(
  //                   'Select Allergies',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: medicationsList.length,
  //                     itemBuilder: (context, index) {
  //                       final allergy = medicationsList[index];
  //                       final isSelected = selectedMedication.contains(
  //                         allergy['name'],
  //                       );
  //                       return CheckboxListTile(
  //                         title: Text(allergy['name']),
  //                         value: isSelected,
  //                         onChanged: (bool? value) {
  //                           setState(() {
  //                             if (value == true) {
  //                               selectedMedication.add(allergy['name']);
  //                             } else {
  //                               selectedMedication.remove(allergy['name']);
  //                             }
  //                           });
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     allergiesController.text = selectedMedication.join(', ');
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text("Done"),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }