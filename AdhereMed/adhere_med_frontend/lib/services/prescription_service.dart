import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:http/http.dart' as http;

class PrescriptionMedicationService {
  static String baseUrl =
      '$base_url/medication/prescriptions/'; // replace with your actual endpoint

  static Future<List<PrescriptionMedication>> fetchAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => PrescriptionMedication.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prescription medications');
    }
  }

  static Future<PrescriptionMedication> create(
    PrescriptionMedication item,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return PrescriptionMedication.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create prescription medication');
    }
  }
}
