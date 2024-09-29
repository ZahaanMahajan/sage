import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sage_app/features/chat/screens/chat.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const InviteCodeScreen(),
                    ),
                    (Route<dynamic> route) => false);
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ]),
          body: const Center(
            child: Text(
              "Home",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ChatScreen(chatRoomId: 'VOnbWL7Ql6yVbFFJKezt'),
                ),
              );
            },
            child: const Icon(Icons.ad_units),
          ),
        );
      },
    );
  }
}
