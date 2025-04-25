class AIDiagnosis {
  final List<String> inputSymptoms;
  final String predictedDisease;
  final String otherSymptoms;
  final String suggestedCures;
  final String doctorToVisit;
  final String riskLevel;

  AIDiagnosis({
    required this.inputSymptoms,
    required this.predictedDisease,
    required this.otherSymptoms,
    required this.suggestedCures,
    required this.doctorToVisit,
    required this.riskLevel,
  });

  factory AIDiagnosis.fromJson(Map<String, dynamic> json) {
    return AIDiagnosis(
      inputSymptoms: List<String>.from(json['input_symptoms']),
      predictedDisease: json['predicted_disease'],
      otherSymptoms: json['other_symptoms'],
      suggestedCures: json['suggested_cures'],
      doctorToVisit: json['doctor_to_visit'],
      riskLevel: json['risk_level'],
    );
  }
}
