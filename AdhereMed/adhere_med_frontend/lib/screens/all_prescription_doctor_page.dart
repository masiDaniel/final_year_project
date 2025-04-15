import 'package:adhere_med_frontend/models/prescription_model.dart';
import 'package:adhere_med_frontend/services/prescription_services.dart';
import 'package:flutter/material.dart';

// Main Widget
class AllPrescriptionPage extends StatefulWidget {
  const AllPrescriptionPage({Key? key}) : super(key: key);

  @override
  State<AllPrescriptionPage> createState() => _AllPrescriptionPageState();
}

class _AllPrescriptionPageState extends State<AllPrescriptionPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Prescription> prescriptions = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    try {
      final data = await PrescriptionService().fetchPrescriptions();
      setState(() {
        prescriptions = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching prescriptions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Prescription> filterPrescriptions({bool? isCompleted}) {
    return prescriptions.where((p) {
      final matchesSearch = p.instructions.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesStatus = isCompleted == null || p.isCompleted == isCompleted;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prescriptions"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Active"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search prescriptions...',
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
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildList(filterPrescriptions()), // All
                          buildList(
                            filterPrescriptions(isCompleted: false),
                          ), // Active
                          buildList(
                            filterPrescriptions(isCompleted: true),
                          ), // Completed
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget buildList(List<Prescription> prescriptions) {
    if (prescriptions.isEmpty) {
      return const Center(child: Text("No prescriptions found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        final p = prescriptions[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: p.isCompleted ? Colors.green[400] : const Color(0xFF85A9BD),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ID: ${p.id}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Instructions: ${p.instructions}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: ${p.datePrescribed.split('T')[0]}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Status: ${p.isCompleted ? "Completed" : "Active"}",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
