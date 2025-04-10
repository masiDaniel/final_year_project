import 'package:adhere_med_frontend/screens/all_prescription_doctor_page.dart';
import 'package:adhere_med_frontend/screens/appointments_page.dart';
import 'package:adhere_med_frontend/screens/calender_screen.dart';
import 'package:adhere_med_frontend/screens/doctor_prescription_page.dart';
import 'package:adhere_med_frontend/screens/doctors_home_page.dart';
import 'package:adhere_med_frontend/screens/doctors_patient_page.dart';
import 'package:adhere_med_frontend/screens/home_page.dart';
import 'package:adhere_med_frontend/screens/medications_page.dart';
import 'package:adhere_med_frontend/screens/notifications.dart';
import 'package:adhere_med_frontend/screens/patient_details_page.dart';
import 'package:adhere_med_frontend/screens/prescription_page.dart';
import 'package:adhere_med_frontend/screens/sign_in.dart';
import 'package:adhere_med_frontend/screens/sign_up.dart';
import 'package:adhere_med_frontend/screens/symptomps.dart';
import 'package:adhere_med_frontend/screens/symptoms_history.dart';
import 'package:adhere_med_frontend/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Theme Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Can be ThemeMode.light or ThemeMode.dark
      home: MyHomePage(),
      routes: {
        '/sign_in': (context) => SignInScreen(),
        '/sign_up': (context) => SignUpScreen(),
        '/home_page': (context) => HomePage(),
        '/notifications': (context) => Notifications(),
        '/symptoms': (context) => SymptomsScreen(),
        '/symptomshistory': (context) => SymptomsHistory(),
        '/prescription_page': (context) => PrescriptionPage(),
        '/medication_page': (context) => MedicationsPage(),
        '/calender_page': (context) => CalendarScreen(),
        '/appointment_page': (context) => AppointmentsPage(),
        '/doctors_home_page': (context) => DoctorsHomePage(),
        '/doctors_prescription_page': (context) => DoctorPrescriptionPage(),
        '/all_doctors_prescription_page': (context) => AllPrescriptionPage(),
        '/doctors_all_patient_page': (context) => PatientsPage(),
        '/doctors_patient_details_page': (context) => PatientDetailsPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Transforming\nHealthcare!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),

                const SizedBox(height: 40),

                // Subtitle
                Text(
                  'One step at a time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 60),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sign Up Button
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Sign In Button
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.teal),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_in');
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.teal),
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
