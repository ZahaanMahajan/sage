import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/widgets/custom_textfield.dart';
import 'package:sage_app/features/auth/login/bloc/login_bloc.dart';
import 'package:sage_app/features/home/screens/home_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is LoginLoading) const CircularProgressIndicator(),
                  TextFieldWithTitle(
                    title: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Password',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                            LoginSubmitted(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            ),
                          );
                    },
                    child: const Text("Login"),
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
