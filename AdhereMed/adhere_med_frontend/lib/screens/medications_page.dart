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
