import 'package:adhere_med_frontend/components/custom_input_field.dart';
import 'package:adhere_med_frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  bool rememberMe = false;
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  void loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('saved_email');
    String? savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Health,\nOur Priority.",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    CustomTextField(
                      controller: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email,
                      onTap: () => print("Email field tapped"),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    CustomTextField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),

                    // Sign Up & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/sign_up'),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    CheckboxListTile(
                      title: Text("Remember Me"),
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final user = await login(
                              emailController.text,
                              passwordController.text,
                            );

                            if (rememberMe) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                'saved_email',
                                emailController.text,
                              );
                              await prefs.setString(
                                'saved_password',
                                passwordController.text,
                              );
                            } else {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('saved_email');
                              await prefs.remove('saved_password');
                            }

                            // Navigate based on user type
                            switch (user.userType) {
                              case 'patient':
                                Navigator.pushNamed(context, '/home_page');
                                break;
                              case 'doctor':
                                Navigator.pushNamed(
                                  context,
                                  '/doctors_home_page',
                                );
                                break;
                              case 'pharmacist':
                                Navigator.pushNamed(context, '/pharmacy_home');
                                break;
                              default:
                                // fallback or error screen
                                Navigator.pushNamed(context, '/error_page');
                            }
                          } catch (e) {
                            String errorMsg = 'Login failed. Please try again.';

                            if (e is Exception) {
                              errorMsg = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                              ),
                            );
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
                          "Sign In",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
