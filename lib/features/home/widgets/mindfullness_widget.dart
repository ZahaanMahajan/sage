import 'package:flutter/material.dart';

class MindfulnessWidget extends StatelessWidget {
  const MindfulnessWidget({
    required this.imagePath,
    required this.title,
    super.key,
  });

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 24,
              left: 12,
              right: 36,
              bottom: 12,
            ),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(5, 5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(-5, -5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 120,
            color: Colors.tealAccent.withOpacity(0.3),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    BoxShadow(
                      offset: const Offset(1, 1),
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
