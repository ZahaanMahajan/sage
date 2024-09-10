import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';
import 'package:sage_app/features/home/bloc/home_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
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
        );
      },
    );
  }
}
