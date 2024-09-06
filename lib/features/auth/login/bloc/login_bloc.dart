import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Something went wrong. Please try again.'));
      }
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}
