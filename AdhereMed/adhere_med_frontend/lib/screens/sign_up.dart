import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome on\nBoard.\nSign Up.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: firstNameController,
                hintText: "Enter your first name",
                icon: Icons.email,
                onTap: () {
                  print("Email field tapped");
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: lastNameController,
                hintText: "Enter your last name",
                icon: Icons.email,
                onTap: () {
                  print("Email field tapped");
                },
              ),
              SizedBox(height: 20),

              CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
                icon: Icons.email,
                onTap: () {
                  print("Email field tapped");
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: "Enter your password",
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: passwordConfirmationController,
                hintText: "confirm your pasword",
                icon: Icons.email,
                onTap: () {
                  print("Email field tapped");
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
