import 'dart:async';

import 'package:adhere_med_frontend/components/custom_button.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/prescription_page.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late Future<List<PrescriptionMedication>> _medications;
  late Future<List<Prescription>> _prescriptions;
  @override
  void initState() {
    super.initState();

    _medications = PrescriptionMedicationService.fetchAll();
    _prescriptions = PrescriptionService().fetchPrescriptions();

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      _currentPage = (_currentPage + 1) % 2;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  String getCurrentTimeOfDay() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  List<Map<String, dynamic>> getFilteredMeds(List<Map<String, dynamic>> meds) {
    String timeOfDay = getCurrentTimeOfDay();
    return meds
        .where((med) => med['is_active'] == true && med[timeOfDay] == true)
        .toList();
  }

  List<PrescriptionMedication> getFilteredMedsFromModel(
    List<PrescriptionMedication> meds,
  ) {
    final timeOfDay = getCurrentTimeOfDay();
    return meds
        .where((med) => med.isActive == true && med.getTimeBool(timeOfDay))
        .toList();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          imageUrl != null
                              ? NetworkImage(imageUrl)
                              : AssetImage('assets/images/default_profile.png')
                                  as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Text("hi daniel"),
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
                  height: 300,
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
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    CustomButton(
                      label: 'Medication',
                      onTap: () {
                        Navigator.pushNamed(context, '/medications');
                      },
                    ),
                    CustomButton(
                      label: 'Details',
                      onTap: () {
                        Navigator.pushNamed(context, '/doctor_details_page');
                      },
                    ),
                    CustomButton(
                      label: 'Symptoms',
                      onTap: () {
                        Navigator.pushNamed(context, '/symptoms');
                      },
                    ),
                    CustomButton(
                      label: 'History',
                      onTap: () {
                        Navigator.pushNamed(context, '/symptomshistory');
                      },
                    ),
                    CustomButton(
                      label: 'Prescriptions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PrescriptionPage(
                                  prescription: _prescriptions,
                                ),
                          ),
                        );
                      },
                    ),
                    CustomButton(
                      label: 'calender',
                      onTap: () {
                        Navigator.pushNamed(context, '/calender_page');
                      },
                    ),
                    CustomButton(
                      label: 'Appointments',
                      onTap: () {
                        Navigator.pushNamed(context, '/appointment_page');
                      },
                    ),
                    CustomButton(
                      label: 'Doctor',
                      onTap: () {
                        Navigator.pushNamed(context, '/doctors_home_page');
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Morning medication:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),
                SizedBox(height: 20),

                // This goes in your widget build method:
                FutureBuilder<List<PrescriptionMedication>>(
                  future: _medications, // Your async data source
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error loading medications"));
                    }

                    // Get the filtered meds using your method
                    final filteredMeds = getFilteredMedsFromModel(
                      snapshot.data!,
                    );

                    return filteredMeds.isEmpty
                        ? Center(child: Text("No medication for this time"))
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                filteredMeds.map((med) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xFFD9D9D9),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${med.medication}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        );
                  },
                ),

                SizedBox(height: 20),
                Text(
                  "Active prescriptions :",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),
                SizedBox(height: 20),

                FutureBuilder<List<Prescription>>(
                  future:
                      _prescriptions, // Your future that fetches the prescriptions
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error loading prescriptions"));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No prescriptions available"));
                    }

                    // Use the snapshot data here
                    final prescriptions = snapshot.data!;

                    return Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                                prescriptions.map((prescription) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => MedicationsPage1(
                                                  prescriptionId:
                                                      prescription.id,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 250,
                                        width: 170,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Prescription ${prescription.id}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              prescription.instructions,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicationTimeWidget extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final String timeOfDay;

  const MedicationTimeWidget({
    Key? key,
    required this.medications,
    required this.timeOfDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredMeds =
        medications.where((med) {
          if (med['is_active'] != true) return false;
          return med[timeOfDay] == true;
        }).toList();

    if (filteredMeds.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "${timeOfDay[0].toUpperCase()}${timeOfDay.substring(1)} medication:",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D557F),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                filteredMeds.map((med) {
                  return Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: Center(
                          child: Text(
                            'Med ID: ${med['medication']}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
