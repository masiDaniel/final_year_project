import 'package:adhere_med_frontend/components/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final String? imageUrl = null;
    return Scaffold(
      body: Padding(
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

              Container(
                height: 300,
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset('assets/images/medical_insights.jpeg'),
                  ],
                ),
              ),

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
                    label: 'Symptoms',
                    onTap: () {
                      Navigator.pushNamed(context, '/symptoms');
                    },
                  ),
                  CustomButton(
                    label: 'Appointments',
                    onTap: () {
                      Navigator.pushNamed(context, '/symptomshistory');
                    },
                  ),
                  CustomButton(
                    label: 'Prescriptions',
                    onTap: () {
                      Navigator.pushNamed(context, '/medications');
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text("Morning medication:"),
              SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.blue,
                      height: 90,
                      width: 90,
                      child: Text('Panadol'),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Colors.blue,
                      height: 90,
                      width: 90,
                      child: Text('Panadol'),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Colors.blue,
                      height: 90,
                      width: 90,
                      child: Text('Panadol'),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Colors.blue,
                      height: 90,
                      width: 90,
                      child: Text('Panadol'),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: Colors.blue,
                      height: 90,
                      width: 90,
                      child: Text('Panadol'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Text("Active prescriptions:"),
              SizedBox(height: 20),

              Container(
                color: Colors.grey,
                height: 300,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.blue,
                        height: 200,
                        width: 150,
                        child: Text("prescription 1"),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        color: Colors.blue,
                        height: 200,
                        width: 150,
                        child: Text("prescription 1"),
                      ),
                      const SizedBox(width: 10),

                      Container(
                        color: Colors.blue,
                        height: 200,
                        width: 150,
                        child: Text("prescription 1"),
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
