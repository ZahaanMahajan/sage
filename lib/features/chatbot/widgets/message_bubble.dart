import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/core/constants/colors.dart';
import 'package:sage_app/core/constants/enums.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.imgUrl,
    required this.size,
    required this.text,
    required this.isUser,
    required this.isLiked,
    required this.isFirstRun,
    required this.completionId,
    required this.operationType,
    required this.indexPosition,
    required this.messageLength,
    super.key,
  });

  final Size size;
  final String text;
  final bool isUser;
  final bool isLiked;
  final String imgUrl;
  final bool isFirstRun;
  final int indexPosition;
  final int messageLength;
  final String completionId;
  final OperationType operationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUser ? Colors.green : Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListTile(

        title: isUser
            ? Text(
                text.trim(),
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                ),
              )
            : !isFirstRun && indexPosition == messageLength - 1
                ? AnimatedTextKit(
                    repeatForever: false,
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                    totalRepeatCount: 0,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        text.trim(),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text.trim(),
                    style: const TextStyle(
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
      ),
    );
  }
}
