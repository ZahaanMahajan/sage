import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/anonymous_chat/screens/student_view.dart';
import 'package:sage_app/features/anonymous_chat/screens/teacher_view.dart';
import 'package:sage_app/features/anonymous_chat/cubit/anonymous_chat_cubit.dart';
import 'package:sage_app/repository/anonymous_chat_repository.dart';

class AnonymousChat extends StatelessWidget {
  const AnonymousChat({super.key, required this.isStudent});

  final bool isStudent;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AnonymousChatRepository(),
      child: BlocProvider(
        create: (context) => AnonymousChatCubit(),
        child: (isStudent) ? const StudentView() : const TeacherView(),
      ),
    );
  }
}
