part of 'signup_bloc.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class ShowVerifyEmailView extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}

class EmailVerificationPending extends SignUpState {}

class EmailVerificationFailed extends SignUpState {}

class EmailVerificationSuccess extends SignUpState {}
