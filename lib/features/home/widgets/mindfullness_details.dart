import 'package:flutter/material.dart';

class MindfullnessDetails extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const MindfullnessDetails({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Image section
                Image.asset(
                  imagePath,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Title over the image
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black54,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 18, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
