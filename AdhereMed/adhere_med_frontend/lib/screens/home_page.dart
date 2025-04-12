import 'dart:async';

import 'package:adhere_med_frontend/components/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      _currentPage = (_currentPage + 1) % 2;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = null;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          imageUrl != null
                              ? NetworkImage(imageUrl)
                              : AssetImage('assets/images/default_profile.png')
                                  as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Text("hi daniel"),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                      icon: Icon(Icons.notifications),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text("Medical tips:"),
                SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent manual scroll
                    children: [
                      // Image slide
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/medical_insights.jpeg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),

                      // Centered text slide
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D557F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Medical insights are transforming the future of healthcare.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    CustomButton(
                      label: 'Medication',
                      onTap: () {
                        Navigator.pushNamed(context, '/medications');
                      },
                    ),
                    CustomButton(
                      label: 'Details',
                      onTap: () {
                        Navigator.pushNamed(context, '/doctor_details_page');
                      },
                    ),
                    CustomButton(
                      label: 'Symptoms',
                      onTap: () {
                        Navigator.pushNamed(context, '/symptoms');
                      },
                    ),
                    CustomButton(
                      label: 'History',
                      onTap: () {
                        Navigator.pushNamed(context, '/symptomshistory');
                      },
                    ),
                    CustomButton(
                      label: 'Prescriptions',
                      onTap: () {
                        Navigator.pushNamed(context, '/prescription_page');
                      },
                    ),
                    CustomButton(
                      label: 'calender',
                      onTap: () {
                        Navigator.pushNamed(context, '/calender_page');
                      },
                    ),
                    CustomButton(
                      label: 'Appointments',
                      onTap: () {
                        Navigator.pushNamed(context, '/appointment_page');
                      },
                    ),
                    CustomButton(
                      label: 'Doctor',
                      onTap: () {
                        Navigator.pushNamed(context, '/doctors_home_page');
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Morning medication:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),
                SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: Center(child: Text('Panadol')),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: Center(child: Text('strepsils')),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: Center(child: Text('Piriton')),
                      ),
                      const SizedBox(width: 10),

                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: Center(child: Text('Aspirin')),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  "Active prescriptions :",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D557F),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            height: 250,
                            width: 170,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text("prescription 1"),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 250,
                            width: 170,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text("prescription 1"),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 250,
                            width: 170,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text("prescription 1"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
