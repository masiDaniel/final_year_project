class Diagnosis {
  final int id;
  final String title;
  final String? description;
  final String? dateDiagnosed;
  final String severity;
  final bool followUpRequired;
  final String notes;
  final int patientId;
  final int doctorId;

  Diagnosis({
    required this.id,
    required this.title,
    this.description,
    this.dateDiagnosed,
    required this.severity,
    required this.followUpRequired,
    required this.notes,
    required this.patientId,
    required this.doctorId,
  });

  // Convert a JSON object into a Diagnosis object
  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateDiagnosed: json['date_diagnosed'],
      severity: json['severity'],
      followUpRequired: json['follow_up_required'],
      notes: json['notes'],
      patientId: json['patient'],
      doctorId: json['doctor'],
    );
  }

  // Convert a Diagnosis object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_diagnosed': dateDiagnosed,
      'severity': severity,
      'follow_up_required': followUpRequired,
      'notes': notes,
      'patient': patientId,
      'doctor': doctorId,
    };
  }
}
