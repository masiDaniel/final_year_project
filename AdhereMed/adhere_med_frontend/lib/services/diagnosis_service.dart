import 'dart:convert';
import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:http/http.dart' as http;

class DiagnosisService {
  final String baseUrl; // The base URL for your API

  DiagnosisService({required this.baseUrl});

  // Fetch all diagnoses
  Future<List<Diagnosis>> fetchDiagnoses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/diagnoses'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Diagnosis.fromJson(json)).toList();
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
      final response = await http.get(Uri.parse('$baseUrl/diagnoses/$id'));

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
  Future<Diagnosis> createDiagnosis(Diagnosis diagnosis) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/prescription/diagnosis/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(diagnosis.toJson()),
      );

      if (response.statusCode == 201) {
        return Diagnosis.fromJson(jsonDecode(response.body));
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
        Uri.parse('$baseUrl/diagnoses/$id'),
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
      final response = await http.delete(Uri.parse('$baseUrl/diagnoses/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }
}
