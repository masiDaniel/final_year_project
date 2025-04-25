import 'dart:async';

import 'package:adhere_med_frontend/components/custom_button.dart';
import 'package:adhere_med_frontend/models/medication_model.dart';
import 'package:adhere_med_frontend/models/prescribed_medication.dart';
import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/screens/medications_page_1.dart';
import 'package:adhere_med_frontend/screens/prescription_page.dart';
import 'package:adhere_med_frontend/services/medication_service.dart';
import 'package:adhere_med_frontend/services/prescribed_medications_service.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:adhere_med_frontend/services/user_service.dart';
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
  late Future<List<Medication>> _medications;
  late Future<List<PrescriptionMedication>> _prescribedMedications;
  late Future<List<Prescription>> _prescriptions;
  late List<Medication> medicationsList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // _initializeNotifications();
    _medications = MedicationService().getMedication();
    _prescribedMedications = PrescriptionMedicationService.fetchAll();
    _prescriptions = PrescriptionService().fetchPrescriptions();
    _fetchMedications();

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      _currentPage = (_currentPage + 1) % 2;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // Function to fetch medications and update state
  Future<void> _fetchMedications() async {
    try {
      List<Medication> fetchedMedications =
          await MedicationService().getMedication();
      setState(() {
        medicationsList = fetchedMedications;
        loading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      setState(() {
        loading = false; // Set loading to false in case of an error
      });
      print("Error fetching medications: $e");
    }
  }

  String getMedicationNameById(int medicationId) {
    // Assuming _medications is populated with a list of Medication objects
    List<Medication> medications = medicationsList;
    print('these are the medications $medications');
    print('this is the id $medicationId');

    // Find the medication that matches the given ID
    final medication = medications.firstWhere(
      (medication) => medication.id == medicationId,
      orElse:
          () => Medication(
            id: medicationId, // The ID you are looking for
            name: 'Medication Name', // Name of the medication
            genericName: 'Generic Name', // Optional: Generic Name
            brandName: 'Brand Name', // Optional: Brand Name
            description:
                'This is a description of the medication', // Description is required
            dosageForm: 'Tablet', // Dosage form is required
            strength: '500mg', // Strength is required
            routeOfAdministration:
                'Oral', // Route of administration is required
            sideEffects: 'Nausea, dizziness', // Side effects are required
            interactions:
                'May interact with alcohol', // Drug interactions are required
            contraindications:
                'Not recommended for pregnant women', // Contraindications are required
            manufacturer: 'PharmaCorp', // Optional: Manufacturer
            approvalDate: '2021-01-01', // Required: Approval date
            expiryDate: '2023-01-01', // Required: Expiry date
            requiresPrescription: true, // Required: Prescription needed
            stockQuantity: 100, // Required: Stock quantity
            price: '50.00', // Required: Price
            createdAt: '2021-01-01', // Required: Created date
            updatedAt: '2021-12-01', // Required: Updated date
          ), // Default value if no match
    );

    return medication.name!;
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
              leading: Icon(Icons.medical_services_outlined),
              title: Text('Doctors'),
              onTap: () {
                Navigator.pushNamed(context, '/doctor_details_page');
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
                Center(
                  child: Wrap(
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
                        label: 'Appointments',
                        onTap: () {
                          Navigator.pushNamed(context, '/appointment_page');
                        },
                      ),
                      CustomButton(
                        label: 'Diagnoses',
                        onTap: () {
                          Navigator.pushNamed(context, '/diagnoses');
                        },
                      ),
                    ],
                  ),
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

                FutureBuilder<List<PrescriptionMedication>>(
                  future: _prescribedMedications,
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
                                      height: 250,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(
                                          0xFF0D557F,
                                        ), // Darker blue for white text contrast
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Medication:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              getMedicationNameById(
                                                med.medication,
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Frequency:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${med.frequency}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Dosage:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${med.dosage}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Instructions:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${med.instructions}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
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
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            children:
                                prescriptions.map((prescription) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        final filteredMeds =
                                            _prescribedMedications.then(
                                              (meds) =>
                                                  meds
                                                      .where(
                                                        (med) =>
                                                            med.prescription ==
                                                            prescription.id,
                                                      )
                                                      .toList(),
                                            );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => MedicationsPage1(
                                                  prescriptionId:
                                                      prescription.id,
                                                  prescribedMedications:
                                                      filteredMeds,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 160,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0D557F),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Prescription #${prescription.id}',
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
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
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
