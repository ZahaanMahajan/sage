import 'package:flutter/material.dart';
import 'package:sage_app/core/constants/assets_manager.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/features/chatbot/widgets/message_box.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  TextEditingController messageController = TextEditingController();

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

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MessageBox(
          textController: messageController,
          generateResponse: () {},
          isTyping: false,
        ),
      ),
    );
  }
}
