import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/repository/chat_repository.dart';
import 'package:sage_app/features/chat/screens/chat_view.dart';
import 'package:sage_app/features/chat/bloc/conversation_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chatRoomId});

  final String chatRoomId;
  @override
  Widget build(BuildContext context) {
    log('Chat Room id: $chatRoomId');
    return RepositoryProvider(
      create: (context) => ChatRepository(),
      child: BlocProvider(
        create: (context) => ConversationBloc(),
        child: ChatView(chatRoomId: chatRoomId),
      ),
    );
  }
}
