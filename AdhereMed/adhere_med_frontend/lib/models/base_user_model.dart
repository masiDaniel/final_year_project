///
/// this has not been done well
///
class User {
  final String username;
  final String email;
  final String userType;
  final Map<String, dynamic>? profile;

  User({
    required this.username,
    required this.email,
    required this.userType,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      userType: json['user_type'],
      profile:
          json['profile'] != null
              ? Map<String, dynamic>.from(json['profile'])
              : null,
    );
  }
}
