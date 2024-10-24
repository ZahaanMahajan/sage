import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sage_app/core/widgets/custom_appbar.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';
import 'package:sage_app/features/home/widgets/mood_tracker.dart';
import 'package:sage_app/features/chatbot/screen/chatbot_screen.dart';
import 'package:sage_app/features/home/widgets/mindfullness_details.dart';
import 'package:sage_app/features/home/widgets/mindfullness_widget.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: CustomAppBar(
            trailing: IconButton(
              onPressed: () {
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Logout'),
                    content: const Text(
                      "Are you sure, you want to logout?",
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const InviteCodeScreen(),
                              ),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              top: 70,
              left: 18,
              right: 18,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.teal.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hey ${UserSession.instance.username}!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const MoodTracker(),
                            Text(
                              'Mindfulness',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.teal.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MindfullnessDetails(
                                                title: 'Spirituality',
                                                description: StringManager
                                                    .spiritualityGuidance,
                                                imagePath:
                                                    StringManager.spirituality,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const MindfulnessWidget(
                                          imagePath: StringManager.spirituality,
                                          title: 'Spirituality',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MindfullnessDetails(
                                                title: 'Breathing',
                                                description: StringManager
                                                    .breathingDescription,
                                                imagePath:
                                                    StringManager.breathing,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const MindfulnessWidget(
                                          imagePath: StringManager.breathing,
                                          title: 'Breathing',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MindfullnessDetails(
                                                title: 'Journaling',
                                                description: StringManager
                                                    .journalingGuidance,
                                                imagePath:
                                                    StringManager.journaling,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const MindfulnessWidget(
                                          imagePath: StringManager.journaling,
                                          title: 'Journaling',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MindfullnessDetails(
                                                title: 'Meditation',
                                                description: StringManager
                                                    .meditationGuidance,
                                                imagePath:
                                                    StringManager.meditation,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const MindfulnessWidget(
                                          imagePath: StringManager.meditation,
                                          title: 'Meditation',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ChatBotScreen(),
                          ),
                        );
                      },
                      label: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Start a session with ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: 'Sage',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
