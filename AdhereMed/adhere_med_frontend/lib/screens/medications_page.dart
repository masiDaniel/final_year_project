import 'package:flutter/material.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<MedicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0D557F),
                  borderRadius: BorderRadius.circular(12), // Smoother corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ), // Added padding for better spacing
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items to the left
                    children: [
                      // Image section with better sizing
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ), // Added padding for better spacing
                          child: Container(
                            height:
                                150, // Increased height for better visibility of the image
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Rounded corners for the container
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(
                                    0,
                                    4,
                                  ), // Soft shadow for depth effect
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Ensure the image is clipped with rounded corners
                              child: Image.asset(
                                'assets/images/medical_image.jpeg',
                                fit:
                                    BoxFit
                                        .cover, // Ensures the image covers the container's space
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16), // Added space after the image
                      // Medication Name section (Amoxil)
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .end, // Align the text to the right
                        children: [
                          Text(
                            "Amoxil",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ), // Spacing between name and dates

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0D557F),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Image.asset(
                                  'assets/images/medical_image.jpeg',
                                  fit:
                                      BoxFit
                                          .cover, // Makes it cover the entire container
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text("Amoxil")],
                      ),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text("Date"),
                          Spacer(),
                          Text("3rd May 2024"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
