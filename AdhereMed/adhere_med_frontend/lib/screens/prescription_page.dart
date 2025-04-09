import 'package:flutter/material.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Dr evin masi"),
                        Container(height: 100, width: 100, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [Text("Date"), Spacer(), Text("3rd May 2024")],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [Text("Date"), Spacer(), Text("3rd May 2024")],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [Text("Date"), Spacer(), Text("3rd May 2024")],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [Text("Date"), Spacer(), Text("3rd May 2024")],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [Text("Date"), Spacer(), Text("3rd May 2024")],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text('Powered by ahderemed'),
          ],
        ),
      ),
    );
  }
}
