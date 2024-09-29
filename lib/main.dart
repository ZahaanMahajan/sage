import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/core/utils/config.dart';
import 'package:sage_app/firebase_options.dart';

import 'core/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await fetchData();
  runApp(const MyApp());
}

Future<void> fetchData() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await Config.fetchApiKey();
  await Config.fetchAndStoreUserData(uid);
}
