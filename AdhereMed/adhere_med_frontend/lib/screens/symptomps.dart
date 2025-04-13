import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:adhere_med_frontend/models/symptom_model.dart';
import 'package:adhere_med_frontend/services/symptom_service.dart';
import 'package:flutter/material.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptompsScreenState();
}

class _SymptompsScreenState extends State<SymptomsScreen> {
  final TextEditingController mainSymptomController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController travelHistoryController = TextEditingController();
  final TextEditingController additionalDescriptionController =
      TextEditingController();

  List<String> selectedAllergies = [];

  // Simulated backend response
  final List<Map<String, dynamic>> allergiesList = [
    {'id': 1, 'name': 'Peanuts'},
    {'id': 2, 'name': 'Dust'},
    {'id': 3, 'name': 'Pollen'},
    {'id': 4, 'name': 'Milk'},
  ];

  void _showAllergiesPicker() {
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
                      itemCount: allergiesList.length,
                      itemBuilder: (context, index) {
                        final allergy = allergiesList[index];
                        final isSelected = selectedAllergies.contains(
                          allergy['name'],
                        );
                        return CheckboxListTile(
                          title: Text(allergy['name']),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedAllergies.add(allergy['name']);
                              } else {
                                selectedAllergies.remove(allergy['name']);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      allergiesController.text = selectedAllergies.join(', ');
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

  // Submit symptom function
  void _submitSymptom() async {
    final symptom = Symptom(
      mainSymptom: mainSymptomController.text,
      duration: durationController.text,
      severity: severityController.text,
      allergies: allergiesController.text,
      travelHistory: travelHistoryController.text,
      additionalDescription: additionalDescriptionController.text,
      createdAt: DateTime.now(),
      id: 0,
      userId: 1,
    );
    print("this is the ymptom ${symptom}");

    try {
      final createdSymptom = await SymptomService().createSymptom(symptom);
      ;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptom created: ${createdSymptom.mainSymptom}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create symptom')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Symptoms")),

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
                      "log your symptoms",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            CustomTextField(
              controller: mainSymptomController,
              hintText: "Main symptom",
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: durationController,
              hintText: "Duration",
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: severityController,
              hintText: "Severity",
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: allergiesController,
              hintText: "Allergies",
              onTap: _showAllergiesPicker,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: travelHistoryController,
              hintText: "Travel history",
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: additionalDescriptionController,
              hintText: "Additional description",
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _submitSymptom, // Submit the symptom
                  child: Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF85A9BD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Submit Symptoms",
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
