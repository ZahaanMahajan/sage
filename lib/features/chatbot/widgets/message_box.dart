import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    required this.textController,
    required this.generateResponse,
    required this.isTyping,
    super.key,
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
        hintText: 'Send a message...',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: () => isTyping ? null : generateResponse(),
          child: const Icon(
            Icons.send,
            color: Colors.black,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
