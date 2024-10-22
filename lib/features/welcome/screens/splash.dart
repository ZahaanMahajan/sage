import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sage_app/core/app/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSignStatus();
  }

  Future<void> _checkSignStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InviteCodeScreen(),
          ),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Landing(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.teal.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox(
        height: 300,
        child: Image.asset(StringManager.sageLogo),

      ),
      ),
    );
  }
}
