part of 'invite_code_bloc.dart';

abstract class InviteCodeEvent {}

final class CheckInviteCode extends InviteCodeEvent {
  final String code;
  CheckInviteCode(this.code);
}

final class AlreadyHaveAccount extends InviteCodeEvent {}
