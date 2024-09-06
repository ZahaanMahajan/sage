part of 'signup_bloc.dart';

abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String username;
  final String password;
  final int age;
  final bool hadCounsellingBefore;
  final String inviteCode;

  SignUpSubmitted({
    required this.email,
    required this.username,
    required this.password,
    required this.age,
    required this.hadCounsellingBefore,
    required this.inviteCode,
  });
}
