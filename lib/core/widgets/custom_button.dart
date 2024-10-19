import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.title,
    required this.onPressed,
    this.linearGradientBegin = const Color(0xFFFFFFFF),
    this.linearGradientEnd = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFE3E3E7),
    this.textColor = const Color(0xFF475569),
    this.borderRadius,
    this.imagePath,
    super.key,
  });

  final void Function()? onPressed;
  final Color linearGradientBegin;
  final Color linearGradientEnd;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color borderColor;
  final String? imagePath;
  final Color? textColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(30),
          color: (linearGradientBegin == const Color(0xFFFFFFFF) &&
              linearGradientEnd == const Color(0xFFFFFFFF))
              ? backgroundColor
              : null,
          gradient: (linearGradientBegin != const Color(0xFFFFFFFF) ||
              linearGradientEnd != const Color(0xFFFFFFFF))
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              linearGradientBegin,
              linearGradientEnd,
            ],
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            imagePath != null
                ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                imagePath!,
                height: 24,
                width: 24,
              ),
            )
                : const SizedBox(width: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}