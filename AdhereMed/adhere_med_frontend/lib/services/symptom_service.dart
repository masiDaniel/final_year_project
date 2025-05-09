import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/ai_diagnosis.dart';
import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/models/symptom_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:http/http.dart' as http;

class SymptomService {
  // Fetch all diagnoses
  Future<List<Symptom>> fetchSymptomps() async {
    try {
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse('$base_url/core/symptoms/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Symptom.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load diagnoses');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fetch a single diagnosis by ID
  Future<Diagnosis> fetchDiagnosisById(int id) async {
    try {
      final response = await http.get(Uri.parse('$base_url/diagnoses/$id'));

      if (response.statusCode == 200) {
        return Diagnosis.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create a new diagnosis
  Future<Symptom> createSymptom(Symptom symptom) async {
    try {
      final token = await TokenService.getAccessToken();
      final response = await http.post(
        Uri.parse('$base_url/core/symptoms/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(symptom.toJson()),
      );

      if (response.statusCode == 201) {
        return Symptom.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing diagnosis
  Future<Diagnosis> updateDiagnosis(int id, Diagnosis diagnosis) async {
    try {
      final response = await http.put(
        Uri.parse('$base_url/diagnoses/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(diagnosis.toJson()),
      );

      if (response.statusCode == 200) {
        return Diagnosis.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete a diagnosis
  Future<void> deleteDiagnosis(int id) async {
    try {
      final response = await http.delete(Uri.parse('$base_url/diagnoses/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to send symptoms to the backend
  Future<List<AIDiagnosis>> askAI(List<String> symptoms) async {
    final response = await http.post(
      Uri.parse('$base_url/core/predict/'), // Replace with your endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'symptoms': symptoms,
        'non_text_data': [
          // Add the necessary non-text data here (e.g., age, gender, etc.)
          [30, 1, 0, 1, 0, 0, 1], // Example data, replace as needed
        ],
      }),
    );

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((item) => AIDiagnosis.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
