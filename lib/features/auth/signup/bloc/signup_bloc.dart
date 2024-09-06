import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/repository/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
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
      } else {
        emit(SignUpFailure('Something went wrong. Please try again.'));
      }

      emit(SignUpSuccess());
    } catch (error) {
      emit(SignUpFailure(error.toString()));
    }
  }
}
