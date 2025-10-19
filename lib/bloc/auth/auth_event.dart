import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String login;
  final String password;

  const AuthLoginRequested({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password];
}

class AuthSignupRequested extends AuthEvent {
  final String login;
  final String firstname;
  final String name;
  final String email;
  final String password;
  final File? profileImage;

  const AuthSignupRequested({
    required this.login,
    required this.firstname,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
  });

  @override
  List<Object?> get props => [login, firstname, name, email, password, profileImage];
}

class AuthLogoutRequested extends AuthEvent {}
