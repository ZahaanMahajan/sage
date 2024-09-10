import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';
import 'package:sage_app/features/auth/signup/view/verify_email_view.dart';
import 'package:sage_app/repository/auth_repository.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => SignUpBloc()..add(SendVerificationMail()),
        child: const VerifyEmailView(),
      ),
    );
  }
}
