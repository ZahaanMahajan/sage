import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.textController,
    required this.generateResponse,
    required this.isTyping,
  });

  final TextEditingController textController;
  final Function generateResponse;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: textController,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) => isTyping ? null : generateResponse(),
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Send a message',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: () => isTyping ? null : generateResponse(),
          child: const Icon(
            color: Colors.black,
            Icons.send,
          ),
        ),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
