class UserDetails {
  final String username;
  final String email;
  final String userType;

  UserDetails({
    required this.username,
    required this.email,
    required this.userType,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      username: json['username'],
      email: json['email'],
      userType: json['user_type'],
    );
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
