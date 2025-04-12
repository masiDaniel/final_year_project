import 'package:adhere_med_frontend/models/symptom_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomsHistory extends StatefulWidget {
  const SymptomsHistory({super.key});

  @override
  State<SymptomsHistory> createState() => _SymptomsHistoryState();
}

class _SymptomsHistoryState extends State<SymptomsHistory> {
  final List<Symptom> symptoms = [
    Symptom('Fever and headache', DateTime.now()),
    Symptom('Mlaria', DateTime.now()),
    Symptom('Body weakness', DateTime.now().subtract(const Duration(days: 1))),
    Symptom(
      'Shortness of breath',
      DateTime.now().subtract(const Duration(days: 4)),
    ),
    Symptom(
      'Cough and sore throat',
      DateTime.now().subtract(const Duration(days: 12)),
    ),
    Symptom('Improved energy levels', DateTime(2024, 9, 15)),
    Symptom('Mild fatigue', DateTime(2024, 1, 24)),
  ];

  String groupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference =
        today.difference(DateTime(date.year, date.month, date.day)).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference <= 7) return 'Last Week';
    if (difference <= 30) return 'Last Month';
    return DateFormat('MMMM yyyy').format(date);
  }

  Map<String, List<Symptom>> groupSymptoms(List<Symptom> symptoms) {
    final Map<String, List<Symptom>> grouped = {};
    for (final symptom in symptoms) {
      final label = groupLabel(symptom.date);
      grouped.putIfAbsent(label, () => []).add(symptom);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupSymptoms(symptoms);

    return Scaffold(
      appBar: AppBar(title: const Text('Symptoms History')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children:
            grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...entry.value.map((symptom) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(width: 2, height: 40, color: Colors.blue),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  symptom.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 6,
                                ), // spacing between description and time
                                Text(
                                  DateFormat(
                                    'yyyy-MM-dd HH:mm',
                                  ).format(symptom.date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
      ),
    );
  }
}
