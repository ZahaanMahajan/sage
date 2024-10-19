import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/widgets/floating_snack_bar.dart';
import 'package:sage_app/features/chatbot/bloc/chatbot_bloc.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sage - Mental Health Counselor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.teal.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBotBloc, ChatBotState>(
              listener: (context, state) {
                if (state is ChatErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
                if (state is ChatLoadedState && state.showWarning) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(top: 20.0),
                      content: FloatingSnackBar(
                        message: "I'm sorry to hear that."
                            " You should speak to someone about yourself.",
                        onDismissed: () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return DashChat(
                  currentUser: context.read<ChatBotBloc>().user,
                  onSend: (ChatMessage message) {
                    context.read<ChatBotBloc>().add(SendMessageEvent(message));
                  },
                  messages: state is ChatLoadedState ? state.messages : [],
                  typingUsers:
                      state is ChatLoadedState ? state.typingUsers : [],
                  messageOptions: MessageOptions(
                    currentUserContainerColor: Colors.black,
                    containerColor: Colors.teal.shade100,
                    textColor: Colors.black87,
                  ),
                  inputOptions: const InputOptions(
                    inputTextStyle: TextStyle(color: Colors.black87),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
