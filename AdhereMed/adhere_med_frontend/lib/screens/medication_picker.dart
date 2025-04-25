import 'package:flutter/material.dart';
import 'package:adhere_med_frontend/models/medication_model.dart';
import 'package:adhere_med_frontend/services/medication_service.dart';

class MedicationPickerDialog extends StatefulWidget {
  @override
  _MedicationPickerDialogState createState() => _MedicationPickerDialogState();
}

class _MedicationPickerDialogState extends State<MedicationPickerDialog> {
  List<Medication> _allMedications = [];
  List<Medication> _filteredMedications = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  // Fetch medications and handle error gracefully
  void _loadMedications() async {
    try {
      List<Medication> meds = await MedicationService().getMedication();
      setState(() {
        _allMedications = meds;
        _filteredMedications = meds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show an error message if something goes wrong
      _showErrorDialog('Failed to load medications. Please try again later.');
    }
  }

  // Filter medications based on search query
  void _filterMedications(String query) {
    final filtered =
        _allMedications.where((med) {
          return med.name!.toLowerCase().contains(query.toLowerCase()) ||
              med.genericName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
    setState(() {
      _searchQuery = query;
      _filteredMedications = filtered;
    });
  }

  // Show error dialog in case of issues
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Medication"),
      content:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                height: 300, // Set a fixed height for the content area
                child: Column(
                  children: [
                    // Search input field
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search medication...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: _filterMedications,
                    ),
                    SizedBox(height: 10),
                    // Display filtered medications
                    _filteredMedications.isEmpty
                        ? Center(child: Text("No medications found"))
                        : ListView.builder(
                          shrinkWrap:
                              true, // Allow the list to take only necessary space
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling of ListView to allow parent to scroll
                          itemCount: _filteredMedications.length,
                          itemBuilder: (context, index) {
                            final med = _filteredMedications[index];
                            return ListTile(
                              title: Text(med.name!),
                              subtitle: Text(med.genericName!),
                              onTap: () => Navigator.of(context).pop(med),
                            );
                          },
                        ),
                  ],
                ),
              ),
    );
  }
}
