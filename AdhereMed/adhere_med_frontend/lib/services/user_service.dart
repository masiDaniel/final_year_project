import 'dart:convert';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/models/base_user_model.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<User> login(String email, String password) async {
  final url = Uri.parse('$base_url/api/token/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);

    await TokenService.saveTokens(jsonData['access'], jsonData['refresh']);
    await TokenService.saveUserType(jsonData['user_type']);
    await TokenService.saveUserName(jsonData['username']);

    // Return parsed user
    return User.fromJson(jsonData);
  } else {
    // Handle errors
    final error = jsonDecode(response.body);
    throw Exception(error['detail'] ?? 'Login failed');
  }
}

Future<bool> logout(BuildContext context) async {
  final url = Uri.parse('$base_url/api/logout/');
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');
  final token = await TokenService.getAccessToken();
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'refresh': refreshToken}),
  );

  if (response.statusCode == 205) {
    Navigator.pushNamedAndRemoveUntil(context, '/landing', (route) => false);
    return true;
  } else {
    // Handle errors
    final error = jsonDecode(response.body);
    throw Exception(error['detail'] ?? 'Logout failed');
  }
}
