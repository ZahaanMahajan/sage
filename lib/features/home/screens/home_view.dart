import 'package:flutter/material.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/widgets/custom_appbar.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';
import 'package:sage_app/features/home/widgets/custom_drawer.dart';
import 'package:sage_app/features/home/widgets/mood_tracker.dart';
import 'package:sage_app/features/chatbot/screen/chatbot_screen.dart';

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
            trailing: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 32,
                child: Text(
                  UserSession.instance.username?[0] ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
          drawer: const HomeDrawer(),
          body: Container(
            padding: const EdgeInsets.only(
              top: 100,
              left: 24,
              right: 24,
            ),
            /*decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.teal.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 40,
                ),
                Text(
                  'Hey ${UserSession.instance.username}!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 40),
                const MoodTracker(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                                const ChatBotScreen()),
                      );
                    },
                    child: const Text(
                      "Sage",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
