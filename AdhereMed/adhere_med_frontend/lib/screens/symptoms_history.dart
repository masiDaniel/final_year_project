import 'package:adhere_med_frontend/models/ai_diagnosis.dart';
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

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final entry = grouped.entries.elementAt(index);
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
            },
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
  AIDiagnosis? response;

  Future<void> _sendToAI() async {
    setState(() => loading = true);
    try {
      // Prepare symptom texts
      final symptomsList = selected.map((s) => s.mainSymptom).toList();
      print("this is the request");
      // Send the request to the backend API and get the response
      final result = await SymptomService().askAI(symptomsList);
      print('this is the result ${result}');
      print("this is the result");

      setState(() {
        response =
            result.isNotEmpty ? result[0] : null; // Display the first result
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        response = null;
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Predicted Disease', response!.predictedDisease),
            _buildInfoRow('Other Symptoms', response!.otherSymptoms),
            _buildInfoRow('Suggested Cures', response!.suggestedCures),
            _buildInfoRow('Doctor to Visit', response!.doctorToVisit),
            _buildInfoRow('Risk Level', response!.riskLevel),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? Colors.grey[850]
                  : Colors.white, // Adjust for light/dark theme
          borderRadius: BorderRadius.circular(
            12.0,
          ), // Rounded corners for a modern look
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1), // Shadow based on theme
              blurRadius: 6.0, // Soft shadow for elevation effect
              offset: Offset(0, 2), // Slight offset for shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(
          16.0,
        ), // Padding inside container for spacing
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label styling with bold and clear font
            Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold, // Bold label for emphasis
                fontFamily: 'Roboto', // Clean, professional font
                color:
                    isDarkMode
                        ? Colors.white
                        : Colors.black, // Adjust color for dark/light theme
              ),
            ),
            const SizedBox(width: 8),
            // Value text styling, adjusted for readability
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Roboto', // Consistent font usage
                  fontWeight: FontWeight.w400, // Regular weight for text
                  color:
                      isDarkMode
                          ? Colors.white70
                          : Colors.black.withOpacity(
                            0.7,
                          ), // Light/Dark mode text color
                  height: 1.4, // Adequate line height for readability
                ),
                textAlign:
                    TextAlign.justify, // Text alignment for neat presentation
              ),
            ),
          ],
        ),
      ),
    );
  }
}
