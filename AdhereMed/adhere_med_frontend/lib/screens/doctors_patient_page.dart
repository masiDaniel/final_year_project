import 'package:adhere_med_frontend/models/doctors_model.dart';
import 'package:flutter/material.dart';
import 'package:adhere_med_frontend/components/env.dart';
import 'package:adhere_med_frontend/services/patient_service.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key}) : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  late Future<List<Patient>> _patients;
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();

  final List<String> assignedPatients = ["James M.", "Alice K.", "Brian N."];

  @override
  void initState() {
    super.initState();
    _patients = PatientService().getPatients();
    _patients.then((data) {
      setState(() {
        _allPatients = data;
        _filteredPatients = data;
      });
    });

    _searchController.addListener(() {
      filterPatients(_searchController.text);
    });
  }

  void filterPatients(String query) {
    final filtered =
        _allPatients.where((patient) {
          return patient.userDetails.username.toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();

    setState(() {
      _filteredPatients = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildPatientCard(Patient patient) {
    final user = patient.userDetails;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:
                  user.profilePic != null && user.profilePic!.isNotEmpty
                      ? NetworkImage('$base_url${user.profilePic!}')
                      : AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'
                            .trim()
                            .isNotEmpty
                        ? '${user.firstName ?? ''} ${user.lastName ?? ''}'
                        : user.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                    Text(
                      user.phoneNumber!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  Text(user.email, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patients")),
      body: FutureBuilder<List<Patient>>(
        future: _patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Assigned Patients section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Assigned Patients",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: assignedPatients.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D557F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              assignedPatients[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a patient...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filtered patient list
                  Expanded(
                    child:
                        _filteredPatients.isEmpty
                            ? const Center(child: Text("No patients found."))
                            : ListView.builder(
                              itemCount: _filteredPatients.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/doctors_patient_details_page',
                                      arguments: _filteredPatients[index],
                                    );
                                  },
                                  child: buildPatientCard(
                                    _filteredPatients[index],
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
