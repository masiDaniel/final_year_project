import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

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
                  onTap: () => print("First name field tapped"),
                ),
                const SizedBox(height: 15),

                // Last Name
                CustomTextField(
                  controller: lastNameController,
                  hintText: "Enter your last name",
                  icon: Icons.person_outline,
                  onTap: () => print("Last name field tapped"),
                ),
                const SizedBox(height: 15),

                // Email
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                  onTap: () => print("Email field tapped"),
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
                const SizedBox(height: 40),

                // Sign Up button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // You can add form validation logic here if needed
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
