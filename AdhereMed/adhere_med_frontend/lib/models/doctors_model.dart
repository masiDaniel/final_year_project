class UserDetails {
  final int id;
  final String username;
  final String email;
  final String userType;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profilePic;
  final String? passportPic;
  final String? idScan;
  final bool isActive;
  final bool isSuperuser;
  final DateTime dateJoined;

  UserDetails({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePic,
    this.passportPic,
    this.idScan,
    required this.isActive,
    required this.isSuperuser,
    required this.dateJoined,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      userType: json['user_type'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      profilePic: json['profile_pic'],
      passportPic: json['passport_pic'],
      idScan: json['id_scan'],
      isActive: json['is_active'],
      isSuperuser: json['is_superuser'],
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_pic': profilePic,
      'passport_pic': passportPic,
      'id_scan': idScan,
      'is_active': isActive,
      'is_superuser': isSuperuser,
      'date_joined': dateJoined.toIso8601String(),
    };
  }
}

class Doctor {
  final int id;
  final String licenseNo;
  final int userId;
  final UserDetails userDetails;

  Doctor({
    required this.id,
    required this.licenseNo,
    required this.userId,
    required this.userDetails,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      licenseNo: json['liscense_no'],
      userId: json['user_id'],
      userDetails: UserDetails.fromJson(json['user_details']),
    );
  }
}

class Patient {
  final int id;
  final String memberNo;
  final int userId;
  final UserDetails userDetails;

  Patient({
    required this.id,
    required this.memberNo,
    required this.userId,
    required this.userDetails,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      memberNo: json['member_no'],
      userId: json['user_id'],
      userDetails: UserDetails.fromJson(json['user_details']),
    );
  }
}
