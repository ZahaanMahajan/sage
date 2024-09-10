import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_loginSubmitted);
  }

  FutureOr<void> _loginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final userID =
          await AuthRepository().loginUser(event.email, event.password);

      if (userID != null) {
        if (_auth.currentUser?.emailVerified == true) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Email not verified. Please verify your email.'));
        }
      } else {
        emit(LoginFailure('Something went wrong. Please try again.'));
      }
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}
