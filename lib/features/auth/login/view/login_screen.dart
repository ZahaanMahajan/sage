import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/login/bloc/login_bloc.dart';
import 'package:sage_app/repository/auth_repository.dart';

import 'login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginView(),
      ),
    );
  }
}
