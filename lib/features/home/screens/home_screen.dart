import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';
import 'package:sage_app/features/home/screens/home_view.dart';
import 'package:sage_app/repository/home_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: const HomeView(),
      ),
    );
  }
}
