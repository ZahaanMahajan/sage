import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/invite/bloc/invite_code_bloc.dart';
import 'package:sage_app/repository/auth_repository.dart';

import 'invite_code_view.dart';

class InviteCodeScreen extends StatelessWidget {
  const InviteCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => InviteCodeBloc(),
        child: InviteCodeView(),
      ),
    );
  }
}
