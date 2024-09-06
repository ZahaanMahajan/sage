part of 'invite_code_bloc.dart';

abstract class InviteCodeState {}

final class InviteCodeInitial extends InviteCodeState {}

final class InviteCodeLoading extends InviteCodeState {}

final class InviteCodeValid extends InviteCodeState {}

final class InviteCodeUsed extends InviteCodeState {}

final class InviteCodeInvalid extends InviteCodeState {}

final class InviteCodeError extends InviteCodeState {
  final String error;

  InviteCodeError(this.error);
}

final class ShowLoginScreen extends InviteCodeState {}
