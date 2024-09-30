// lib/features/chatbot/widgets/resources_widget.dart
import 'package:flutter/material.dart';

class ResourcesWidget extends StatelessWidget {
  const ResourcesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Helpful Resources',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency: 911',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'National Suicide Prevention Lifeline: 1-800-273-8255',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Crisis Text Line: Text HOME to 741741',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}