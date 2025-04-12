class PrescriptionMedication {
  final int id;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;
  final bool morning;
  final bool afternoon;
  final bool evening;
  final int prescription;
  final int medication;

  PrescriptionMedication({
    required this.id,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.prescription,
    required this.medication,
  });

  factory PrescriptionMedication.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedication(
      id: json['id'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
      morning: json['morning'],
      afternoon: json['afternoon'],
      evening: json['evening'],
      prescription: json['prescription'],
      medication: json['medication'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'morning': morning,
      'afternoon': afternoon,
      'evening': evening,
      'prescription': prescription,
      'medication': medication,
    };
  }
}
