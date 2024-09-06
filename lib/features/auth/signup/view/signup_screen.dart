import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';
import 'package:sage_app/repository/auth_repository.dart';

import 'signup_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    required this.inviteCode,
    super.key,
  });

  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => SignUpBloc(),
        child: SignUpView(inviteCode: inviteCode),
      ),
    );
  }
}
