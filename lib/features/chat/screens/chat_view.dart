import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:sage_app/features/chat/bloc/conversation_bloc.dart';
import 'package:sage_app/features/chat/widgets/custom_chat_input.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatRoomId});

  final String chatRoomId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    context
        .read<ConversationBloc>()
        .add(GetInitialMessages(chatRoomid: widget.chatRoomId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        log('State is : $state');
        if (state is ConversationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ChatRoomLoadingError) {
          return const Scaffold(
            body: Center(child: Text('Coun\'t find chat...!')),
          );
        }
        if (state is ConversationLoaded) {
          final messages = context.read<ConversationBloc>().messages;

          return Scaffold(
            body: Chat(
              messages: messages,
              showUserAvatars: true,
              customBottomWidget: CustomChatInput(
                onSendPressed: (types.PartialText message) {
                  context
                      .read<ConversationBloc>()
                      .add(SendMessage(message.text));
                },
              ),
              onSendPressed: (types.PartialText message) {
                context.read<ConversationBloc>().add(SendMessage(message.text));
              },
              user: context.read<ConversationBloc>().user,
              onEndReached: () async {
                final bloc = context.read<ConversationBloc>();
                bloc.add(LoadMoreChats(chatRoomid: bloc.chatRoomId));
              },
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Internal error...!')),
        );
      },
    );
  }
}
