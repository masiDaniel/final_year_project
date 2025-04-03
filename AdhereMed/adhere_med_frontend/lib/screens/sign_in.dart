import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Health,\nOur Priority.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),

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
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");
                    },
                    child: Text("Sign In"),
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
