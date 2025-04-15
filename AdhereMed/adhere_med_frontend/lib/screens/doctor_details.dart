import 'package:adhere_med_frontend/components/env.dart';
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
    final user = doctor.userDetails;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 35,
              backgroundImage:
                  user.profilePic != null && user.profilePic!.isNotEmpty
                      ? NetworkImage('$base_url${user.profilePic!}')
                      : AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
            ),
            SizedBox(width: 16),

            // User Info
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

                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'License: ${doctor.licenseNo}',
                        style: TextStyle(fontSize: 13),
                      ),
                      Spacer(),
                      Text(
                        user.userType,
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
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
