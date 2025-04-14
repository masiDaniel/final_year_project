import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:http/http.dart' as http;

class DiagnosisService {
  // Fetch all diagnoses
  Future<List<Diagnosis>> fetchDiagnoses() async {
    try {
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse('$base_url/prescription/diagnosis/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse('$base_url/prescription/diagnosis/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
      final token = await TokenService.getAccessToken();
      final response = await http.post(
        Uri.parse('$base_url/prescription/diagnosis/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
      final token = await TokenService.getAccessToken();
      final response = await http.patch(
        Uri.parse('$base_url/prescription/diagnosis/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
      final token = await TokenService.getAccessToken();
      final response = await http.delete(
        Uri.parse('$base_url/prescription/diagnosis/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete diagnosis');
      }
    } catch (e) {
      rethrow;
    }
  }
}
