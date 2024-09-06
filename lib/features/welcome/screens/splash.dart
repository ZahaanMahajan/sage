import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';
//import 'package:sage_app/features/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InviteCodeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: CupertinoActivityIndicator(
        color: Colors.grey,
      ),
    );
  }
}
