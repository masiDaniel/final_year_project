class Prescription {
  final int id;
  final String datePrescribed;
  final String instructions;
  final int diagnosisId;
  final int prescribedBy;
  final int prescribedTo;
  final bool isCompleted;

  Prescription({
    required this.id,
    required this.datePrescribed,
    required this.instructions,
    required this.diagnosisId,
    required this.prescribedBy,
    required this.prescribedTo,
    required this.isCompleted,
  });

  // Convert a JSON object into a Prescription object
  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      datePrescribed: json['date_prescribed'],
      instructions: json['instructions'],
      diagnosisId: json['diagnosis'],
      prescribedBy: json['prescribed_by'],
      prescribedTo: json['prescribed_to'],
      isCompleted: json['is_completed'],
    );
  }

  // Convert a Prescription object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_prescribed': datePrescribed,
      'instructions': instructions,
      'diagnosis': diagnosisId,
      'prescribed_by': prescribedBy,
      'prescribed_to': prescribedTo,
    };
  }
}
