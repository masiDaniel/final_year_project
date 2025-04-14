import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:http/http.dart' as http;

class PrescriptionService {
  // Fetch all prescriptions
  Future<List<Prescription>> fetchPrescriptions() async {
    try {
      final token = await TokenService.getAccessToken();
      final response = await http.get(
        Uri.parse('$base_url/prescription/prescription/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Prescription.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load prescriptions');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fetch a single prescription by ID
  Future<Prescription> fetchPrescriptionById(int id) async {
    try {
      final response = await http.get(Uri.parse('$base_url/prescriptions/$id'));

      if (response.statusCode == 200) {
        return Prescription.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create a new prescription
  Future<Prescription> createPrescription(Prescription prescription) async {
    try {
      final response = await http.post(
        Uri.parse('$base_url/prescriptions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prescription.toJson()),
      );

      if (response.statusCode == 201) {
        return Prescription.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing prescription
  Future<Prescription> updatePrescription(
    int id,
    Prescription prescription,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$base_url/prescriptions/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prescription.toJson()),
      );

      if (response.statusCode == 200) {
        return Prescription.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update prescription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete a prescription
  Future<void> deletePrescription(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$base_url/prescriptions/$id'),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete prescription');
      }
    } catch (e) {
      rethrow;
    }
  }
}
