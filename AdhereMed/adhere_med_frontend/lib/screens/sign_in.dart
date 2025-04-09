import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Health,\nOur Priority.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: emailController,
                      hintText: "Enter your em ail",
                      icon: Icons.email,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/sign_up');
                          },
                          child: Text("Sign up"),
                        ),
                        SizedBox(width: 10),
                        Text("Forgot password!"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home_page');
                            print("Email: ${emailController.text}");
                            print("Password: ${passwordController.text}");
                          },
                          child: const Text("Sign In"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
