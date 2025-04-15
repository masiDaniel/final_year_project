import 'package:adhere_med_frontend/models/symptom_model.dart';
import 'package:adhere_med_frontend/services/symptom_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomsHistory extends StatefulWidget {
  const SymptomsHistory({super.key});

  @override
  State<SymptomsHistory> createState() => _SymptomsHistoryState();
}

class _SymptomsHistoryState extends State<SymptomsHistory> {
  late Future<List<Symptom>> _symptoms;

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
      final label = groupLabel(symptom.createdAt);
      grouped.putIfAbsent(label, () => []).add(symptom);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    _symptoms = SymptomService().fetchSymptomps(); // Load symptoms
  }

  void _openAskAI() async {
    final symptoms = await _symptoms;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AskAIBottomSheet(symptoms: symptoms);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAskAI,
        icon: const Icon(Icons.chat),
        label: const Text('Ask Adhere AI'),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(title: const Text('Symptoms History')),
      body: FutureBuilder<List<Symptom>>(
        future: _symptoms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No symptoms found.'));
          }

          final grouped = groupSymptoms(snapshot.data!);

          return ListView(
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
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.blue,
                                ),
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
                                      symptom.mainSymptom,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      DateFormat(
                                        'yyyy-MM-dd HH:mm',
                                      ).format(symptom.createdAt),
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
          );
        },
      ),
    );
  }
}

class AskAIBottomSheet extends StatefulWidget {
  final List<Symptom> symptoms;
  const AskAIBottomSheet({super.key, required this.symptoms});

  @override
  State<AskAIBottomSheet> createState() => _AskAIBottomSheetState();
}

class _AskAIBottomSheetState extends State<AskAIBottomSheet> {
  final Set<Symptom> selected = {};
  bool loading = false;
  String? response;

  Future<void> _sendToAI() async {
    setState(() => loading = true);
    try {
      // Prepare symptom texts
      final symptomsList = selected.map((s) => s.mainSymptom).toList();

      final result = await SymptomService().askAI(symptomsList);

      setState(() {
        response = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        response = 'Failed to get response from Adhere AI.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Symptoms to Ask About'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children:
                widget.symptoms.map((symptom) {
                  final isSelected = selected.contains(symptom);
                  return FilterChip(
                    label: Text(symptom.mainSymptom),
                    selected: isSelected,
                    selectedColor: Colors.blue,
                    onSelected: (selectedNow) {
                      setState(() {
                        isSelected
                            ? selected.remove(symptom)
                            : selected.add(symptom);
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: selected.isEmpty || loading ? null : _sendToAI,
            icon: const Icon(Icons.send),

            label:
                loading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('Ask'),
          ),
          if (response != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            Text(
              'Adhere AI says:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(response!),
          ],
        ],
      ),
    );
  }
}
