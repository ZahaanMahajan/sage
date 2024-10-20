import 'package:sage_app/features/auth/invite/bloc/invite_code_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:sage_app/features/auth/signup/view/signup_screen.dart';
import 'package:sage_app/features/auth/login/view/login_screen.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/core/widgets/custom_button.dart';
import 'package:sage_app/core/widgets/input_field.dart';
import 'package:sage_app/core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InviteCodeView extends StatefulWidget {
  const InviteCodeView({super.key});

  @override
  State<InviteCodeView> createState() => _InviteCodeViewState();
}

class _InviteCodeViewState extends State<InviteCodeView> {
  final TextEditingController inviteCodeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocConsumer<InviteCodeBloc, InviteCodeState>(
            listener: (context, state) {
              final progress = ProgressHUD.of(context);
              if (state is InviteCodeValid) {
                progress?.dismiss();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      inviteCode: inviteCodeController.text.trim(),
                    ),
                  ),
                );
              } else if (state is ShowLoginScreen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else if (state is InviteCodeLoading) {
                progress?.show();
              } else if (state is InviteCodeUsed) {
                progress?.dismiss();
                const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Invite Code Used',
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    message:
                        'The Invitation code you\'ve entered has already been used.',
                    messageTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    contentType: ContentType.help,
                    color: Colors.blueGrey,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (state is InviteCodeError) {
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
              } else if (state is InviteCodeInvalid) {
                progress?.dismiss();
                const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Invalid Code',
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    message:
                        'The Invitation code you entered is invalid. Please use a valid code.',
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
              final size = MediaQuery.of(context).size;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    SizedBox(
                      height: size.height * 0.36,
                      child: Image.asset(StringManager.sageLogo),
                      /*ModelViewer(
                        src: StringManager.loco3dModel,
                        disablePan: true,
                      ),*/
                    ),
                    const Text(
                      'Enter the invitation code to create an account.',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          InputField(
                            controller: inviteCodeController,
                            label: 'Invite Code',
                            filledColor: Colors.teal.shade100,
                            textInputAction: TextInputAction.done,
                            validator: Validators.required,
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            title: 'Submit',
                            textColor: Colors.white,
                            linearGradientBegin: Colors.teal.shade300,
                            linearGradientEnd: Colors.teal.shade500,
                            borderColor: Colors.teal.shade700,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final inviteCode =
                                    inviteCodeController.text.trim();
                                if (inviteCode.isNotEmpty) {
                                  context
                                      .read<InviteCodeBloc>()
                                      .add(CheckInviteCode(inviteCode));
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already have an account?',
                                ),
                                TextSpan(
                                  text: ' Login',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        context.read<InviteCodeBloc>().add(
                                              AlreadyHaveAccount(),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
