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
  final bool isActive;

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
    required this.isActive,
  });

  bool getTimeBool(String time) {
    switch (time) {
      case 'morning':
        return morning;
      case 'afternoon':
        return afternoon;
      case 'evening':
        return evening;
      default:
        return false;
    }
  }

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
      isActive: json['is_active'],
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
