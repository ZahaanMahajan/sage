import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:sage_app/repository/chatbot_repository.dart';

import 'chatbot_view.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ChatBotRepository(),
      child: BlocProvider(
        create: (context) => ChatBotBloc(),
        child: const ChatBotView(),
      ),
    );
  }
}
