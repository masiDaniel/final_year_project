import 'dart:async';

import 'package:adhere_med_frontend/models/diagnosis_model.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/all_diagnoses_page.dart';
import 'package:adhere_med_frontend/screens/doctor_diagnosis_page.dart';
import 'package:adhere_med_frontend/services/diagnosis_service.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:adhere_med_frontend/services/shared_prefrence_data.dart';
import 'package:adhere_med_frontend/services/user_service.dart';
import 'package:flutter/material.dart';

class DoctorsHomePage extends StatefulWidget {
  const DoctorsHomePage({super.key});

  @override
  State<DoctorsHomePage> createState() => _DoctorsHomePageState();
}

class _DoctorsHomePageState extends State<DoctorsHomePage> {
  late List<Diagnosis> diagnosesnow;
  late List<Prescription> prescriptionnow;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late String? username;

  void getUsername() async {
    final value = await TokenService.getUserName();
    List<Diagnosis> diagnoses = await DiagnosisService().fetchDiagnoses();
    List<Prescription> _prescriptions =
        await PrescriptionService().fetchPrescriptions();

    setState(() {
      username = value;
      diagnosesnow = diagnoses;
      prescriptionnow = _prescriptions;
    });
  }

  @override
  void initState() {
    super.initState();

    getUsername();

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      _currentPage = (_currentPage + 1) % 2;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = null;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'Welcome!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home_page');
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month_rounded),
              title: Text('Calender'),
              onTap: () {
                Navigator.pushNamed(context, '/calender_page');
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder:
                          (context) => GestureDetector(
                            onTap: () {
                              Scaffold.of(
                                context,
                              ).openDrawer(); // Will open the drawer
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : AssetImage(
                                            'assets/images/default_profile.png',
                                          )
                                          as ImageProvider,
                            ),
                          ),
                    ),
                    SizedBox(width: 10),
                    Text("hi $username"),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                      icon: Icon(Icons.notifications),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text("Medical tips:"),
                SizedBox(height: 20),

                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent manual scroll
                    children: [
                      // Image slide
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/medical_insights.jpeg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),

                      // Centered text slide
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D557F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Medical insights are transforming the future of healthcare.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Insights:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiagnosisListPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF0D557F),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Diagnoses',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${diagnosesnow.length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF0D557F),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Prescriptions',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${prescriptionnow.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Text(
                  "Quick links:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDiagnosisPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF85A9BD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Diagnose",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        print("submit symptomps");
                        Navigator.pushNamed(
                          context,
                          '/all_doctors_prescription_page',
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF85A9BD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Prescriptions",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        print("submit symptomps");
                        Navigator.pushNamed(
                          context,
                          '/doctors_all_patient_page',
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF85A9BD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Patients",
                            style: TextStyle(color: Colors.white),
                          ),
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
