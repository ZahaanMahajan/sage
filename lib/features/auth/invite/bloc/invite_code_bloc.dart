import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/repository/auth_repository.dart';

import '../../../../core/constants/enums.dart';

part 'invite_code_event.dart';
part 'invite_code_state.dart';

class InviteCodeBloc extends Bloc<InviteCodeEvent, InviteCodeState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  InviteCodeBloc() : super(InviteCodeInitial()) {
    on<CheckInviteCode>(_checkInviteCode);
    on<AlreadyHaveAccount>(_showLoginScreen);
  }

  FutureOr<void> _checkInviteCode(event, emit) async {
    emit(InviteCodeLoading());

    try {
      final inviteCodeStatus =
          await AuthRepository().checkInviteCode(event.code);

      if (inviteCodeStatus == InviteCodeStatus.valid) {
        emit(InviteCodeValid());
      } else if (inviteCodeStatus == InviteCodeStatus.userExist) {
        emit(InviteCodeUsed());
      } else {
        emit(InviteCodeInvalid());
      }
    } catch (e) {
      emit(InviteCodeError(e.toString()));
    }
  }

  FutureOr<void> _showLoginScreen(
      AlreadyHaveAccount event, Emitter<InviteCodeState> emit) {
    emit(ShowLoginScreen());
  }
}
