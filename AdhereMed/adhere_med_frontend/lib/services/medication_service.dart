import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/doctors_model.dart';
import 'package:adhere_med_frontend/models/medication_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:http/http.dart' as http;

class MedicationService {
  final String apiUrl = "$base_url/core/doctor/";

  Future<List<Medication>> getMedication() async {
    final token = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = jsonDecode(response.body);
      return data.map((doctorJson) => Medication.fromJson(doctorJson)).toList();
    } else {
      throw Exception('Failed to load doctor details');
    }
  }

  Future<Doctor> getDoctorDetails(int doctorId) async {
    final token = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse('$apiUrl$doctorId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load doctor details');
    }
  }
}
