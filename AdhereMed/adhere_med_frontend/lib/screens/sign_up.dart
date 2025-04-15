import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/services/sign_up_service.dart';
import 'package:flutter/material.dart';
import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController businessOrMemberController =
      TextEditingController(); // For business_no or member_no

  String selectedUserType = ''; // Track selected user type

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showUserTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select User Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pharmacy"),
                onTap: () {
                  setState(() {
                    selectedUserType = 'pharmacy';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Patient"),
                onTap: () {
                  setState(() {
                    selectedUserType = 'patient';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Doctor"),
                onTap: () {
                  setState(() {
                    selectedUserType = 'doctor';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getExtraFieldHint() {
    switch (selectedUserType) {
      case 'pharmacy':
        return 'Enter your business number';
      case 'doctor':
        return 'Enter your license number';
      case 'patient':
        return 'Enter your member number';
      default:
        return '';
    }
  }

  IconData getExtraFieldIcon() {
    switch (selectedUserType) {
      case 'pharmacy':
        return Icons.store;
      case 'doctor':
        return Icons.medical_services;
      case 'patient':
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome on\nBoard.\nSign Up.",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 30),

                // First Name
                CustomTextField(
                  controller: firstNameController,
                  hintText: "Enter your first name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 15),

                // Last Name
                CustomTextField(
                  controller: lastNameController,
                  hintText: "Enter your last name",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 15),

                // Email
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),

                // Password
                CustomTextField(
                  controller: passwordController,
                  hintText: "Enter your password",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 15),

                // Password Confirmation
                CustomTextField(
                  controller: passwordConfirmationController,
                  hintText: "Confirm your password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                // Add the button to select user type
                GestureDetector(
                  onTap: () {
                    _showUserTypeDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Text(
                      selectedUserType.isEmpty
                          ? "Select User Type"
                          : "Selected: $selectedUserType",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Show the field based on the selected user type
                if (selectedUserType.isNotEmpty)
                  CustomTextField(
                    controller: businessOrMemberController,
                    hintText: getExtraFieldHint(),
                    icon: getExtraFieldIcon(),
                  ),
                const SizedBox(height: 40),

                // Sign Up button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final fieldKey =
                          selectedUserType == 'pharmacy'
                              ? 'business_no'
                              : selectedUserType == 'doctor'
                              ? 'license_no'
                              : 'member_no';

                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                      if (_formKey.currentState?.validate() ?? false) {
                        if (!emailRegex.hasMatch(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter a valid email address",
                              ),
                            ),
                          );
                          return;
                        }

                        if (passwordController.text !=
                            passwordConfirmationController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        // All validations passed
                        final userData = {
                          'username': firstNameController.text,
                          'first_name': firstNameController.text,
                          'last_name': lastNameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'user_type': selectedUserType,
                          fieldKey: businessOrMemberController.text,
                        };

                        signUpService(userData);

                        Navigator.pushNamed(context, '/sign_in');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
