import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/appointment_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  final String baseUrl = '$base_url/core/appointment/';

  // Get all appointments for the logged-in user
  Future<List<Appointment>> getAppointments() async {
    final token = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  // Create a new appointment
  Future<Appointment> createAppointment(Appointment appointment) async {
    final token = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create appointment');
    }
  }

  // Update an appointment
  Future<Appointment> updateAppointment(Appointment appointment) async {
    final token = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update appointment');
    }
  }

  // Delete an appointment
  Future<void> deleteAppointment(int id) async {
    final token = await TokenService.getAccessToken();
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete appointment');
    }
  }
}
