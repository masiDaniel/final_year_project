import 'package:flutter/material.dart';

class AllPrescriptionPage extends StatefulWidget {
  const AllPrescriptionPage({Key? key}) : super(key: key);

  @override
  State<AllPrescriptionPage> createState() => _AllPrescriptionPageState();
}

class _AllPrescriptionPageState extends State<AllPrescriptionPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final List<String> allPrescriptions = [
    "Paracetamol - Active",
    "Ibuprofen - Completed",
    "Amoxicillin - Active",
    "Vitamin D - Completed",
    "Cough Syrup - Active",
  ];

  String searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> filterPrescriptions(List<String> list) {
    return list
        .where((p) => p.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
        body: Column(
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
                  buildList(filterPrescriptions(allPrescriptions)),
                  buildList(
                    filterPrescriptions(
                      allPrescriptions
                          .where((p) => p.contains("Active"))
                          .toList(),
                    ),
                  ),
                  buildList(
                    filterPrescriptions(
                      allPrescriptions
                          .where((p) => p.contains("Completed"))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(List<String> prescriptions) {
    if (prescriptions.isEmpty) {
      return const Center(child: Text("No prescriptions found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFF85A9BD),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              prescriptions[index],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
