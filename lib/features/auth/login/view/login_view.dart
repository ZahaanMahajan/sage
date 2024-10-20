import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:sage_app/features/auth/login/bloc/login_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sage_app/core/widgets/custom_button.dart';
import 'package:sage_app/core/widgets/input_field.dart';
import 'package:sage_app/core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sage_app/core/app/landing.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              final progress = ProgressHUD.of(context);
              if (state is LoginSuccess) {
                progress?.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Landing(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } else if (state is LoginLoading) {
                progress?.show();
              } else if (state is LoginFailure) {
                progress?.dismiss();
                const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Error',
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    message: 'Something went wrong. Please try again later.',
                    messageTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Let's continue your path to peace of mind.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      label: 'Enter Email',
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      label: 'Enter Password',
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: 'Login',
                      linearGradientBegin: Colors.teal.shade300,
                      linearGradientEnd: Colors.teal,
                      borderColor: Colors.teal,
                      textColor: Colors.white,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                ),
                              );
                        }
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
