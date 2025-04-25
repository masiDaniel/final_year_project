import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPrescriptionPage extends StatefulWidget {
  final int diagnosis;
  final int prescribed_by;
  final int prescribed_to;

  const AddPrescriptionPage({
    super.key,
    required this.diagnosis,
    required this.prescribed_by,
    required this.prescribed_to,
  });

  @override
  State<AddPrescriptionPage> createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  final TextEditingController _instructionsController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitPrescription() async {
    if (_instructionsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter instructions")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse("$base_url/prescription/prescription/");
    final token = await TokenService.getAccessToken();

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "diagnosis": widget.diagnosis,
        "prescribed_by": widget.prescribed_by,
        "prescribed_to": widget.prescribed_to,
        "instructions": _instructionsController.text.trim(),
      }),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prescription added successfully!")),
      );
      Navigator.pop(context); // Go back after successful submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add prescription: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Prescription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: "Instructions",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Submit Prescription"),
                  onPressed: _submitPrescription,
                ),
          ],
        ),
      ),
    );
  }
}
