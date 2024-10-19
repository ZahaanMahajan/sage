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
    context.read<ConversationBloc>().messages = [];
    context.read<ConversationBloc>().lastDocument = null;
    context.read<ConversationBloc>().messageIds = {};
    context
        .read<ConversationBloc>()
        .add(GetInitialMessages(chatRoomid: widget.chatRoomId));
  }

  Future<void> _loadMoreMessages() async {
    context
        .read<ConversationBloc>()
        .add(LoadMoreChats(chatRoomid: widget.chatRoomId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationBloc, ConversationState>(
      listener: (context, state) {},
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
            body: Center(child: Text('Couldn\'t find chat...!')),
          );
        }
        if (state is ConversationLoaded) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.white),
            body: StreamBuilder<List<types.Message>>(
              stream: context.read<ConversationBloc>().messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                final messages = snapshot.data!;
                return Chat(
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
                    context
                        .read<ConversationBloc>()
                        .add(SendMessage(message.text));
                  },
                  user: context.read<ConversationBloc>().user,
                  onEndReached: _loadMoreMessages,
                );
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
