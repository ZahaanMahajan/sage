import 'package:flutter/material.dart';

class FloatingSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismissed;

  const FloatingSnackBar({
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    required this.onDismissed,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          Icon(Icons.info, color: textColor),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: onDismissed,
          ),
        ],
      ),
    );
  }
}
