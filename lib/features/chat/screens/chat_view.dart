import 'dart:developer';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:sage_app/features/chat/bloc/conversation_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:sage_app/features/chat/widgets/custom_chat_input.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatRoomId, required this.token});
  final String chatRoomId;
  final String token;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        final cubit = context.read<ConversationBloc>();
        log('State is : $state');

        //* ======= Connection Loading ======= *//
        if (state is ConversationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //* ======= Connection Error ======= *//
        if (state is ChatRoomLoadingError) {
          return const Scaffold(
            body: Center(child: Text('Couldn\'t find chat...!')),
          );
        }

        //* ======= Connection Loaded ======= *//
        if (state is ConversationLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Sage - Anonymous Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.teal.shade300,
            ),
            body: StreamBuilder<List<types.Message>>(
              stream: context.read<ConversationBloc>().messageStream,
              builder: (context, snapshot) {
                //* ======= Connection Error ======= *//
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                //* ======= Connection Error ======= *//
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                //* ======= No Data Found ======= *//
                if (!snapshot.hasData) {
                  return const Center(child: Text('No messages yet'));
                }

                //* ======= Chat UI ======= *//
                final messages = snapshot.data!;
                return Chat(
                  user: cubit.user,
                  messages: messages,
                  showUserAvatars: false,
                  onEndReached: _loadMoreMessages,
                  customBottomWidget: CustomChatInput(
                    onSend: (types.PartialText message) =>
                        cubit.add(SendMessage(message.text)),
                  ),
                  onSendPressed: (types.PartialText message) =>
                      cubit.add(SendMessage(message.text)),
                  bubbleBuilder: _bubbleBuilder,
                  theme: const DefaultChatTheme(
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),
          );
        }

        //* ======= Default State ======= *//
        return const Scaffold(
          body: Center(child: Text('Internal error...!')),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().messages = [];
    context.read<ConversationBloc>().messageIds = {};
    context.read<ConversationBloc>().lastDocument = null;
    context.read<ConversationBloc>().messageingToken = widget.token;

    context
        .read<ConversationBloc>()
        .add(GetInitialMessages(chatRoomid: widget.chatRoomId));

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _loadMoreMessages() async {
    context
        .read<ConversationBloc>()
        .add(LoadMoreChats(chatRoomid: widget.chatRoomId));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      log('App in Background');
    } else if (state == AppLifecycleState.detached) {
      log('App in Killed');
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        color: context.read<ConversationBloc>().user.id != message.author.id ||
                message.type == types.MessageType.image
            ? Colors.teal.shade300
            : const Color(0xff6f61e8),
        padding: const BubbleEdges.all(0),
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 12)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : context.read<ConversationBloc>().user.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
        child: child,
      );
}
