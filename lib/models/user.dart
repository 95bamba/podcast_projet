import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String login;
  final String firstname;
  final String name;
  final String email;
  final String? profileImgPath;
  final int? accountState;
  final String? role;

  const User({
    required this.login,
    required this.firstname,
    required this.name,
    required this.email,
    this.profileImgPath,
    this.accountState,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'] ?? '',
      firstname: json['firstname'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImgPath: json['profileImgPath'],
      accountState: json['accountState'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'firstname': firstname,
      'name': name,
      'email': email,
      'profileImgPath': profileImgPath,
      'accountState': accountState,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [login, firstname, name, email, profileImgPath, accountState, role];
}
