import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adhere_med_frontend/components/env.dart';

Future<Map<String, dynamic>> signUpService(
  Map<String, dynamic> userData,
) async {
  final url = Uri.parse('$base_url/core/register/');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    final decoded = json.decode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return {'success': true, 'message': 'Signup successful'};
    } else {
      return {
        'success': false,
        'message': decoded['message'] ?? 'Signup failed',
        'errors': decoded,
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'An error occurred: $e'};
  }
}
