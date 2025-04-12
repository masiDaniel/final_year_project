import 'package:adhere_med_frontend/screens/full_screen.dart';
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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullImageScreen(
                                        imagePath:
                                            'assets/images/medical_image.jpeg',
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/medical_image.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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

                      const SizedBox(height: 16),

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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullImageScreen(
                                        imagePath:
                                            'assets/images/medical_image.jpeg',
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/medical_image.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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

                      const SizedBox(height: 16),

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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullImageScreen(
                                        imagePath:
                                            'assets/images/medical_image.jpeg',
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/medical_image.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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

                      const SizedBox(height: 16),

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
