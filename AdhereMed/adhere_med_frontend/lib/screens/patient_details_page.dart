import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

class PatientDetailsPage extends StatefulWidget {
  const PatientDetailsPage({super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  // Toggle to display additional details when Request Access is clicked.
  bool showExtendedDetails = false;

  // Dummy history data (most recent first).
  final List<Map<String, String>> historyData = [
    {"date": "5th May 2024", "diagnosis": "Flu", "medication": "Tamiflu"},
    {
      "date": "15th April 2024",
      "diagnosis": "Cold",
      "medication": "Paracetamol",
    },
    {
      "date": "20th March 2024",
      "diagnosis": "Allergy",
      "medication": "Antihistamines",
    },
    // Add more history items if needed.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details"),
        backgroundColor: const Color(0xFF0D557F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Main Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D557F),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Details
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Doctor Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        detailRow("Doctor", "Dr. Evin Masi"),
                        detailRow("Date", "3rd May 2024"),
                        detailRow("Diagnosis", "Malaria"),
                        detailRow("Prescription", "Coartem, Paracetamol"),
                        detailRow("Dosage", "1 tablet x 3 times/day"),
                        detailRow("Duration", "5 days"),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Right Side: Patient Info + Buttons
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Patient Image
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/profile_image.jpeg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "John Doe",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          "Male, Age: 32",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const Text(
                          "Patient ID: #123456",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        // Request Access Button: toggles the extended details
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D557F),
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showExtendedDetails = !showExtendedDetails;
                            });
                          },

                          label: const Text("Request Access"),
                        ),
                        const SizedBox(height: 12),
                        // You can keep the prescribe button active, if required.
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D557F),
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // handle prescribe action
                          },

                          label: const Text("Prescribe"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Display previous diagnosis/history and graph if requested
            if (showExtendedDetails) ...[
              // Previous Diagnosis History Container
              Container(
                height: 200, // Adjust height as needed
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Scrollbar(
                  // Wrapping in Scrollbar for better UX when scrolling
                  child: ListView.builder(
                    itemCount: historyData.length,
                    itemBuilder: (context, index) {
                      final history = historyData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Ladder-style format using a small leading circle
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      history["date"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(history["diagnosis"]!),
                                  ],
                                ),
                              ],
                            ),
                            Text(history["medication"]!),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Graph Container Placeholder
              Container(
                height: 300, // Set appropriate height for your graph
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 80), // Data point for day 1 (80% adherence)
                          FlSpot(1, 90), // Data point for day 2 (90% adherence)
                          FlSpot(2, 75), // Data point for day 3 (75% adherence)
                          FlSpot(3, 85), // Data point for day 4 (85% adherence)
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            const Text(
              'Powered by AdhereMed',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
