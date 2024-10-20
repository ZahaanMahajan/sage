import 'package:sage_app/features/auth/signup/view/verify_email_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:sage_app/features/auth/signup/bloc/signup_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sage_app/core/widgets/custom_button.dart';
import 'package:sage_app/core/widgets/input_field.dart';
import 'package:sage_app/core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              final progress = ProgressHUD.of(context);
              if (state is SignUpSuccess) {
                progress?.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign up successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifyEmailScreen(),
                  ),
                );
              } else if (state is SignUpFailure) {
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
              } else if (state is SignUpLoading) {
                progress?.show();
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
                      "Welcome",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "Start your journey to a healthier mind. We're here to listen, anytime.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      controller: emailController,
                      label: 'Enter Email',
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: usernameController,
                      label: 'Enter UserName',
                      textInputAction: TextInputAction.next,
                      validator: Validators.required,
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 18),
                        Text(
                          'Your username is hidden while taking to other person.',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: passwordController,
                      label: 'Enter Password',
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: ageController,
                      label: 'Enter Age',
                      textInputAction: TextInputAction.next,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: 'Sign Up',
                      linearGradientBegin: Colors.teal.shade300,
                      linearGradientEnd: Colors.teal,
                      borderColor: Colors.teal,
                      textColor: Colors.white,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
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
                        }
                      },
                    ),
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
