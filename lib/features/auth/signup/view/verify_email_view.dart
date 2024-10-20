import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/app/landing.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade200,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is EmailVerificationSuccess) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Landing(),
                  ),
                  (Route<dynamic> route) => false);
              const SnackBar(content: Text('User verified successfully'));
            }
          },
          builder: (context, state) {
            if (state is EmailVerificationPending) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Please check your mail for verification.......",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.teal.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const CupertinoActivityIndicator(),
                  ],
                ),
              );
            }
            if (state is EmailVerificationFailed) {
              return const Center(
                child: Text(
                  "Email verification failed.",
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
