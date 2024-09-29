import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/constants/enums.dart';
import 'package:sage_app/core/constants/assets_manager.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/features/chatbot/bloc/chatbot_bloc.dart';
import 'package:sage_app/features/chatbot/widgets/message_box.dart';
import 'package:sage_app/features/chatbot/widgets/message_bubble.dart';
import 'package:sage_app/features/chatbot/widgets/text_loading.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(AssetManager.logo, color: Colors.black),
            ),
            const SizedBox(width: 10),
            const Text(
              StringManager.appName,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBotBloc, ChatBotState>(
              builder: (context, state) {
                if (state is ChatBotLoading) {
                  return const TextLoading();
                } else if (state is ChatBotSuccess) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(
                        imgUrl: AssetManager.logo,
                        size: MediaQuery.of(context).size,
                        text: message.text,
                        isUser: message.isUser,
                        completionId: message.id,
                        isLiked: false,
                        operationType: OperationType.chat,
                        isFirstRun: false,
                        indexPosition: index,
                        messageLength: state.messages.length,
                      );
                    },
                  );
                } else if (state is ChatBotFailure) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: Text("Start a conversation..."));
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MessageBox(
          textController: messageController,
          generateResponse: () {
            setState(() {
            });
            context
                .read<ChatBotBloc>()
                .add(SendMessage(message: messageController.text));
          },
          isTyping: isTyping,
        ),
      ),
    );
  }
}
