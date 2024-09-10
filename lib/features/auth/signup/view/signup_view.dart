import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/widgets/custom_textfield.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';
import 'package:sage_app/features/auth/signup/view/verify_email_screen.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, required this.inviteCode});

  final String inviteCode;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  bool hadCounsellingBefore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign up successful!')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifyEmailScreen(),
                  ),
                );
              } else if (state is SignUpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is SignUpLoading) const CircularProgressIndicator(),
                  TextFieldWithTitle(
                    title: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Username',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Password',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Age',
                    controller: ageController,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Have taken counselling before?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      DropdownMenu(
                        onSelected: (value) {
                          hadCounsellingBefore = value ?? false;
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: true, label: 'Yes'),
                          DropdownMenuEntry(value: false, label: 'No'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SignUpBloc>().add(
                            SignUpSubmitted(
                              email: emailController.text.trim(),
                              username: usernameController.text.trim(),
                              password: passwordController.text,
                              age: int.parse(ageController.text),
                              hadCounsellingBefore: hadCounsellingBefore,
                              inviteCode: widget.inviteCode,
                            ),
                          );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.controller,
    this.textInputType,
  });

  final String title;
  final TextEditingController controller;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        CustomTextField(
          textEditingController: controller,
          keyboardType: textInputType,
        ),
      ],
    );
  }
}
