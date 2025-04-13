class Symptom {
  final int id;
  final String mainSymptom;
  final String duration;
  final DateTime createdAt;
  final String severity;
  final String additionalDescription;
  final String travelHistory;
  final String allergies;
  final int userId;

  Symptom({
    required this.id,
    required this.mainSymptom,
    required this.duration,
    required this.createdAt,
    required this.severity,
    required this.additionalDescription,
    required this.travelHistory,
    required this.allergies,
    required this.userId,
  });

  // Convert a JSON object into a Diagnosis object
  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'],
      mainSymptom: json['main_symptom'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['created_at']),
      severity: json['severity'],
      additionalDescription: json['additional_description'],
      allergies: json['allergies'],
      userId: json['user'],
      travelHistory: json['travel_history'],
    );
  }

  // Convert a Diagnosis object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'main_symptom': mainSymptom,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'severity': severity,
      'additional_description': additionalDescription,
      'allergies': allergies,
      'user': userId,
      'travel_history': travelHistory,
    };
  }

  @override
  String toString() {
    return 'Symptom(mainSymptom: $mainSymptom, duration: $duration, severity: $severity, allergies: $allergies, travelHistory: $travelHistory, additionalDescription: $additionalDescription)';
  }
}
