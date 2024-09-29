
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TextLoading extends StatelessWidget {
  const TextLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: Colors.grey.shade300,
      size: 30,
    );
  }
}