import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class DoctorPrescriptionPage extends StatefulWidget {
  const DoctorPrescriptionPage({super.key});

  @override
  State<DoctorPrescriptionPage> createState() => _DoctorPrescriptionPageState();
}

class _DoctorPrescriptionPageState extends State<DoctorPrescriptionPage> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController travelHistoryController = TextEditingController();
  final TextEditingController aditionalDescriptionController =
      TextEditingController();

  List<String> selectedMedication = [];

  // Simulated backend response
  final List<Map<String, dynamic>> medicationsList = [
    {'id': 1, 'name': 'Peanuts'},
    {'id': 2, 'name': 'Dust'},
    {'id': 3, 'name': 'Pollen'},
    {'id': 4, 'name': 'Milk'},
  ];

  void _showMedicationsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Allergies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: medicationsList.length,
                      itemBuilder: (context, index) {
                        final allergy = medicationsList[index];
                        final isSelected = selectedMedication.contains(
                          allergy['name'],
                        );
                        return CheckboxListTile(
                          title: Text(allergy['name']),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedMedication.add(allergy['name']);
                              } else {
                                selectedMedication.remove(allergy['name']);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      allergiesController.text = selectedMedication.join(', ');
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("prescription")),

      ///
      ///what does safe area do?
      ///
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  child: Center(
                    child: Text(
                      "Create Prescription",
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
            const SizedBox(height: 10),

            CustomTextField(
              controller: instructionsController,
              hintText: "Instructions",
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: medicationController,
              hintText: "Medications",

              onTap: () {
                _showMedicationsPicker();
                print("list of alergies ");
              },
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    print("submit Prescription");
                  },
                  child: Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF85A9BD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "submit Prescription",
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
    );
  }
}
