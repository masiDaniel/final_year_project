abstract class Profile {
  factory Profile.fromJson(Map<String, dynamic> json, String userType) {
    switch (userType) {
      case 'patient':
        return PatientProfile.fromJson(json);
      case 'doctor':
        return DoctorProfile.fromJson(json);
      case 'pharmacy':
        return PharmacyProfile.fromJson(json);
      default:
        throw Exception('Unknown user type: $userType');
    }
  }
}

class PatientProfile implements Profile {
  final String memberNo;

  PatientProfile({required this.memberNo});

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(memberNo: json['member_no']);
  }
}

class DoctorProfile implements Profile {
  final String licenseNo;
  final String specialization;

  DoctorProfile({required this.licenseNo, required this.specialization});

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      licenseNo: json['license_no'],
      specialization: json['specialization'],
    );
  }
}

class PharmacyProfile implements Profile {
  final String registrationId;
  final String pharmacyName;

  PharmacyProfile({required this.registrationId, required this.pharmacyName});

  factory PharmacyProfile.fromJson(Map<String, dynamic> json) {
    return PharmacyProfile(
      registrationId: json['registration_id'],
      pharmacyName: json['pharmacy_name'],
    );
  }
}
