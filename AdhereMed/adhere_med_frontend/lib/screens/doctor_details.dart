import 'package:adhere_med_frontend/models/doctors_model.dart';
import 'package:adhere_med_frontend/services/doctors_service.dart';
import 'package:flutter/material.dart';

class DoctorListPage extends StatefulWidget {
  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  late Future<List<Doctor>> _doctors;
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _doctors = DoctorService().getDoctors();
    _doctors.then((data) {
      setState(() {
        _allDoctors = data;
        _filteredDoctors = data;
      });
    });

    _searchController.addListener(() {
      filterDoctors(_searchController.text);
    });
  }

  void filterDoctors(String query) {
    final filtered =
        _allDoctors.where((doctor) {
          return doctor.userDetails.username.toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();

    setState(() {
      _filteredDoctors = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildDoctorCard(Doctor doctor) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor ID: ${doctor.id}', style: TextStyle(fontSize: 18)),
            Text(
              'License No: ${doctor.licenseNo}',
              style: TextStyle(fontSize: 18),
            ),
            Text('User ID: ${doctor.userId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              'User Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Username: ${doctor.userDetails.username}'),
            Text('Email: ${doctor.userDetails.email}'),
            Text('User Type: ${doctor.userDetails.userType}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctors')),
      body: FutureBuilder<List<Doctor>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child:
                        _filteredDoctors.isEmpty
                            ? Center(child: Text("No doctors found"))
                            : ListView.builder(
                              itemCount: _filteredDoctors.length,
                              itemBuilder: (context, index) {
                                return buildDoctorCard(_filteredDoctors[index]);
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
