import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';
import 'package:sage_app/features/home/screens/home_screen.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
                (Route<dynamic> route) => false);
            const SnackBar(content: Text('User verified successfully'));
          }
        },
        builder: (context, state) {
          if (state is EmailVerificationPending) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please check your mail for verification......."),
                CupertinoActivityIndicator(),
              ],
            );
          }
          if (state is EmailVerificationFailed) {
            return const Center(
              child: Text("Email verification failed."),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}