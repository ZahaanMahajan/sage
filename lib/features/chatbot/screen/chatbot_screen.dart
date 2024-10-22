import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/constants/constants.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:sage_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:sage_app/repository/chatbot_repository.dart';

import 'chatbot_view.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ChatBotRepository(
        OpenAI.instance.build(
          token: AppConstants.apiKey,
          baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 5),
          ),
          enableLog: true,
        ),
      ),
      child: BlocProvider(
        create: (context) => ChatBotBloc(
          context.read<ChatBotRepository>(),
          ChatUser(
            id: '${UserSession.instance.uid}',
          ),
          ChatUser(id: 'sage_id', firstName: 'Sage'),
        )..add(ChatStartedEvent()),
        child: const ChatBotView(),
      ),
    );
  }
}
