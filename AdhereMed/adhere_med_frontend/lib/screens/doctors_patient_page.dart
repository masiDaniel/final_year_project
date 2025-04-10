import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({Key? key}) : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> assignedPatients = ["James M.", "Alice K.", "Brian N."];

  final List<String> allPatients = [
    "James M.",
    "Alice K.",
    "Brian N.",
    "Stacy W.",
    "Michael B.",
    "Nancy K.",
    "Tobias O.",
  ];

  String searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> filterPatients() {
    return allPatients
        .where(
          (patient) =>
              patient.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patients")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assigned Patients
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Text(
              "Assigned Patients",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
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

          const SizedBox(height: 10),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
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
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Search results
          Expanded(
            child:
                filterPatients().isEmpty
                    ? const Center(child: Text("No patients found."))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filterPatients().length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(filterPatients()[index]),
                            subtitle: const Text("Tap to view details"),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/doctors_patient_details_page',
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
