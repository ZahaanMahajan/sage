import 'package:flutter/cupertino.dart';
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
                  final chatBotBloc = context.read<ChatBotBloc>();
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => BlocProvider.value(
                      value: chatBotBloc,
                      child: CupertinoAlertDialog(
                        title: const Text('Alert'),
                        content: const Text(
                          'Consider seeking professional counseling or request'
                          ' a one-on-one chat with an anonymous teacher.',
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              chatBotBloc.add(RequestAnonymousChat());
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is RequestAnonymousChatExists) {
                  final chatBotBloc = context.read<ChatBotBloc>();
                  Navigator.pop(context);
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => BlocProvider.value(
                      value: chatBotBloc,
                      child: CupertinoAlertDialog(
                        title: const Text('Note'),
                        content: const Text(
                          "Your session will be saved, and you'll have the opportunity "
                          "to chat anonymously with a teacher to share any issues you're "
                          "facing after accepting your request",
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is RequestAnonymousChatSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.teal,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(top: 20.0),
                      content: FloatingSnackBar(
                        message: "Your request for chat is recorded. "
                            "The chat will appear once someone accepts.",
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
