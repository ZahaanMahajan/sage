import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/repository/auth_repository.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SendVerificationMail>(_sendVerificationMail);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final userID = await AuthRepository().signUpUser(
        event.email,
        event.username,
        event.password,
        event.age,
        event.hadCounsellingBefore,
      );

      if (userID != null) {
        await AuthRepository().linkUserWithInviteCode(userID, event.inviteCode);
        await AuthRepository().saveDataToProfile(event.inviteCode, userID);
      } else {
        emit(SignUpFailure('Something went wrong. Please try again.'));
      }

      emit(SignUpSuccess());
    } catch (error) {
      emit(SignUpFailure(error.toString()));
    }
  }

  FutureOr<void> _sendVerificationMail(
      SendVerificationMail event, Emitter<SignUpState> emit) async {
    emit(EmailVerificationPending());
    try {
      await AuthRepository().sendEmailVerificationLink();
      await _checkEmailVerification(emit);
    } catch (e) {
      emit(EmailVerificationFailed());
    }
  }

  Future<void> _checkEmailVerification(Emitter<SignUpState> emit) async {
    const maxAttempts = 60;
    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(const Duration(seconds: 1));
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified == true) {
        emit(EmailVerificationSuccess());
        return;
      }
    }
    emit(EmailVerificationFailed());
  }
}
