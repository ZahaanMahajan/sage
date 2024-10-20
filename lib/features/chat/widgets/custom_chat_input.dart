import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CustomChatInput extends StatefulWidget {
  final Function(types.PartialText) onSendPressed;

  const CustomChatInput({super.key, required this.onSendPressed});

  @override
  CustomChatInputState createState() => CustomChatInputState();
}

class CustomChatInputState extends State<CustomChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSendPressed() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendPressed(types.PartialText(text: _controller.text.trim()));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Type something',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSendPressed,
          ),
        ],
      ),
    );
  }
}
