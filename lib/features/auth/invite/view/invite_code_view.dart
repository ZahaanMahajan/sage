import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/widgets/custom_textfield.dart';
import 'package:sage_app/features/auth/invite/bloc/invite_code_bloc.dart';
import 'package:sage_app/features/auth/login/view/login_screen.dart';
import 'package:sage_app/features/auth/signup/view/signup_screen.dart';

class InviteCodeView extends StatelessWidget {
  InviteCodeView({super.key});

  final TextEditingController inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Invite Code",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textEditingController: inviteCodeController,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final inviteCode = inviteCodeController.text.trim();
                  if (inviteCode.isNotEmpty && inviteCode.length == 6) {
                    context
                        .read<InviteCodeBloc>()
                        .add(CheckInviteCode(inviteCode));
                  }
                },
                child: const Text("Submit"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () =>
                    context.read<InviteCodeBloc>().add(AlreadyHaveAccount()),
                child: const Text("Already have an account? Login"),
              ),
              const SizedBox(height: 20),
              BlocConsumer<InviteCodeBloc, InviteCodeState>(
                listener: (context, state) {
                  if (state is InviteCodeValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                          inviteCode: inviteCodeController.text.trim(),
                        ),
                      ),
                    );
                  }
                  if (state is ShowLoginScreen) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is InviteCodeLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is InviteCodeValid) {
                    return const Text("Invite code is valid!");
                  } else if (state is InviteCodeUsed) {
                    return const Text(
                        "Invite code already used. Please Login!");
                  } else if (state is InviteCodeInvalid) {
                    return const Text("Invite code is invalid!");
                  } else if (state is InviteCodeError) {
                    return Text("Error: ${state.error}");
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
