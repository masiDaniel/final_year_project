// models/appointment.dart

class Appointment {
  final int id;
  final String date;
  final String time;
  final String? reason;
  final String status;
  final String createdAt;
  final int patient;
  final int doctor;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    this.reason,
    required this.status,
    required this.createdAt,
    required this.patient,
    required this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      reason: json['reason'],
      status: json['status'],
      createdAt: json['created_at'],
      patient: json['patient'],
      doctor: json['doctor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'reason': reason,
      'status': status,
      'patient': patient,
      'doctor': doctor,
    };
  }
}
