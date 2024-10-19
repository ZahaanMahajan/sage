import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/core/models/user.dart';

class Config {
  static Future<void> fetchApiKey() async {
    String key = 'sk-proj-WAQLsWgkEuxWdWpnfq5yT3BlbkFJPBhcPrDLWstnRaqlR38z';
    const storage = FlutterSecureStorage();
    await storage.write(key: 'API_KEY', value: key);
    String? apiKey = await storage.read(key: 'API_KEY');
    log('API KEY: $apiKey');
  }

  static Future<void> fetchAndStoreUserData(String uid) async {
    try {
      // Fetch the user document from Firestore

      if (uid.isNotEmpty) {
        DocumentSnapshot documentSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            // Extract the fields from Firestore and initialize UserSession
            UserSession.instance.initialize(
              age: data['age'].toString(),
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              email: data['email'],
              gender: data['gender'],
              hadCounsellingBefore: data['had_counselling_before'],
              profession: data['profession'],
              uid: data['uid'],
              username: data['username'],
            );

            log('User session initialized with username: ${UserSession.instance.username}');
          }
        }else{
          log('No User Document found');
        }
      } else {
        log('No User ID found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }
}
