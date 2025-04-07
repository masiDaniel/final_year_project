import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptompsScreenState();
}

class _SymptompsScreenState extends State<SymptomsScreen> {
  final TextEditingController mainSymptomController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController serverityController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController travelHistoryController = TextEditingController();
  final TextEditingController aditionalDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Symptoms")),

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
                  color: Colors.blue,
                  height: 30,
                  width: 150,
                  child: Text("log your symptomps"),
                ),
              ],
            ),

            const SizedBox(height: 60),

            CustomTextField(
              controller: mainSymptomController,
              hintText: "Main symptom",
            ),

            CustomTextField(
              controller: durationController,
              hintText: "Duration",
            ),
            CustomTextField(
              controller: serverityController,
              hintText: "severity",
            ),
            CustomTextField(
              controller: allergiesController,
              hintText: "alergies",
              onTap: () {
                print("list of alergies");
              },
            ),
            CustomTextField(
              controller: travelHistoryController,
              hintText: "Travel history",
            ),
            CustomTextField(
              controller: aditionalDescriptionController,
              hintText: "Additional description",
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

                  onPressed: () {},
                  child: Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
